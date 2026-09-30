# Attendance location fix

## Verified configuration and source

The numeric values in `backend/src/config/companySettings.json` are now latitude `11.322962`, longitude `77.685142`, radius `1000` meters, with location enforcement enabled. Office timing is `09:40–17:40`, lunch is 30 minutes, and grace is 0 minutes.

Admin reads and saves through `GET/PUT /api/payroll/company-branding`. `companySettingsService.js` reads/writes the settings JSON file; office coordinates are not stored in Prisma. Employee readiness reads the same API, with `Cache-Control: no-store`. Each check-in/check-out independently reads that same file through the backend location service and existing middleware. The database's general shift is synchronized from the central settings when settings are saved or an employee checks in.

## Findings

- The supplied workspace actually contained the previous office coordinates and a 500-meter radius, despite the reported Admin values. The service also had separate old coordinates and a 100-meter fallback. Those coordinate/radius fallbacks are removed; missing/corrupt storage fails closed.
- Partial settings updates previously replaced omitted latitude and longitude with null. Updates now preserve omitted values, normalize numeric strings, reject malformed values with HTTP 422, and replace the settings file atomically.
- Browser location requests omitted accuracy and used a 10-second timeout. They now request a fresh high-accuracy position with a 15-second timeout and send latitude, longitude and accuracy.
- The original Haversine implementation already calculated meters, and no latitude/longitude swap was found. The shared calculation now uses bounded Haversine/atan2 and strict coordinate validation. Both frontend and backend use the same math, but only the backend authorizes punches.
- The old office point is approximately 19.87 meters from the requested point. That difference alone would not explain rejection at the exact office under the previous 500-meter radius. The exact real-world rejection cannot be established without the employee's actual GPS reading.
- The attendance API returned an assigned database shift and omitted the `officeTiming` field expected by the frontend. The calendar also hard-coded its schedule label. Current policy displays now derive from central Admin settings, including lunch/grace.

## Readiness and diagnostics

The dashboard distinguishes checking, verified, outside, denied permission, unavailable position and settings errors. Punch buttons remain disabled until readiness succeeds. Settings/location refresh on dashboard mount, window focus and manual retry. Every punch obtains another fresh position; the backend then independently checks the current saved geofence. Accuracy is diagnostic only and never expands the radius.

When running the frontend with Vite development mode, the dashboard displays current and office coordinates, distance, allowed radius, accuracy and Inside/Outside status. Development logs include the same values. Production builds omit this panel and client diagnostic logs; backend coordinate logs require `NODE_ENV=development`.

## Validation

- 12 targeted regression tests passed, including a full authenticated Admin settings and attendance API flow against an isolated copy of the database and an isolated settings file.
- Synthetic office fixture: `11.322962, 77.685142`, distance **0 meters**, check-in/check-out accepted and recorded in the isolated database.
- Synthetic northward fixture: **999 meters** accepted, **1001 meters** rejected. An equal-distance boundary is accepted.
- Permission denial, timeout/unavailable GPS, missing/malformed coordinates, swapped coordinates, invalid Admin input, numeric string persistence, unrelated partial updates, unreadable settings, client boolean bypass attempts, and settings changes before checkout are covered.
- The final frontend production build passed. Vite reports its existing large-chunk warning.
- Broader backend run: **53/59 passed**. Six failures concern report access, two payroll operations, CL accrual, salary divisor and overtime expectations. See `geofence-test-results.log`; those areas were not changed for this task.
- **Real browser coordinates and real distance: unavailable.** Browser automation failed to connect with `missing field sandboxPolicy` before any GPS reading. Test fixture coordinates are not real browser coordinates. No GPS was overridden and no live attendance punches were made.

To rerun targeted integration tests in PowerShell from the project root, use a fresh isolated database copy:

```powershell
Copy-Item backend/prisma/dev.db backend/prisma/geofence-regression.db
$env:NODE_ENV = 'test'
$env:DATABASE_URL = 'file:./geofence-regression.db'
node --test --test-concurrency=1 backend/tests/attendanceLocation.test.js backend/tests/attendanceLocationFlow.test.js
```

Deploy the `shared` directory alongside `backend` (the backend imports the shared geofence module). Restart the backend and serve the rebuilt frontend to apply the code changes. For an on-site verification, use development mode, open the employee dashboard, allow location access and inspect the diagnostic panel.

## Changed source files

- `backend/src/config/companySettings.json`
- `backend/src/services/companySettingsService.js`
- `backend/src/services/attendanceLocationService.js`
- `backend/src/middleware/attendanceLocationMiddleware.js`
- `backend/src/controllers/payrollController.js`
- `backend/src/controllers/attendanceController.js`
- `shared/attendanceLocation.mjs` (new)
- `frontend/src/utils/attendanceLocation.js`
- `frontend/src/hooks/useAttendanceLocation.js` (new)
- `frontend/src/pages/admin/SettingsPage.jsx`
- `frontend/src/pages/employee/EmployeeDashboard.jsx`
- `frontend/src/pages/employee/AttendanceCalendar.jsx`
- `frontend/src/pages/employee/MyAttendance.jsx`
- `backend/tests/attendanceLocation.test.js`
- `backend/tests/attendanceLocationFlow.test.js` (new)
- `FINAL_OFFICE_RULES_AND_CHANGES.txt`

This report, the broader test log and regenerated `frontend/dist` are also included.
