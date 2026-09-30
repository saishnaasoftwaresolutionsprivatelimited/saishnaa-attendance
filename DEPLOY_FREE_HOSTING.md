# 🚀 How to Host Saishnaa Attendance System for Free

This application is now configured for **Unified Full-Stack Hosting** (Frontend + Backend + SQLite Database running seamlessly on a single port with zero CORS or cookie issues).

---

## 🌟 Method 1: Render.com (Recommended — 100% Free Full-Stack)

Render gives you a free Web Service with free HTTPS (e.g., `https://saishnaa-attendance.onrender.com`).

### Step 1: Push your code to GitHub
1. Open PowerShell or Terminal in this folder:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for free deployment"
   ```
2. Create a new repository on [GitHub](https://github.com/new) (e.g., `saishnaa-attendance`).
3. Link and push your repository:
   ```bash
   git remote add origin https://github.com/<your-username>/saishnaa-attendance.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Deploy on Render
1. Go to [Render.com](https://render.com) and sign in (using GitHub).
2. Click **New +** -> **Web Service**.
3. Select your GitHub repository (`saishnaa-attendance`).
4. Configure the settings (or Render will automatically detect `render.yaml`):
   - **Name**: `saishnaa-attendance` (or any name you prefer)
   - **Runtime**: `Node`
   - **Build Command**: `npm run build`
   - **Start Command**: `npm start`
   - **Instance Type**: `Free`
5. Under **Environment Variables**, add:
   - `NODE_ENV`: `production`
   - `JWT_SECRET`: `saishnaa_super_secret_jwt_key_2026_enterprise_attendance` (or any random string)
   - `DEFAULT_TIMEZONE`: `Asia/Kolkata`
   - `DATABASE_URL`: `file:./dev.db`
6. Click **Deploy Web Service**!

Render will build the React frontend, set up and seed the database, and start the app on your free `https://*.onrender.com` URL.

---

## ⚡ Method 2: Instant Public URL (No GitHub or Hosting Account Required)

If you want an immediate live public link to share or test on your phone right now:

### Using Cloudflare Tunnel:
```bash
# Start your local server:
npm start

# In a second terminal window, run:
npx cloudflared tunnel --url http://localhost:5000
```
This instantly generates a free public HTTPS URL (e.g., `https://random-words.trycloudflare.com`) pointing directly to your running site!

---

## 🔑 Default Login Credentials

Once your site is live, you can sign in immediately with:

- **Admin Portal**: `admin@saishnaa.com` | Password: `Admin@Saishnaa2026!`
- **HR Portal**: `hr@saishnaa.com` | Password: `Hr@Saishnaa2026!`
- **Employee Portal**: `rajesh.k@saishnaa.com` | Password: `Emp@Saishnaa2026!`
