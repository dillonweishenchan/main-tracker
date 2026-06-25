# Sync your Fund Tracker across all devices

This adds a free online database (Supabase) so your fund saves to the cloud and shows up on every device you sign in on. Your data sits in a private row that only your login can read.

You only do steps 1–5 once. Budget about 10 minutes.

---

## 1. Create a free Supabase project

1. Go to **https://supabase.com** and sign up (free).
2. Click **New project**. Give it any name (e.g. "Fund Tracker"), set a database password (save it somewhere), pick a region near you, and create it.
3. Wait ~1 minute for it to finish setting up.

## 2. Create the database table

1. In your project, open **SQL Editor** (left sidebar) → **New query**.
2. Open the file **`supabase-setup.sql`** (included alongside the app), copy everything, paste it in, and click **Run**.
3. You should see "Success." That creates a `funds` table with security rules so only you can read your own data.

## 3. Turn off email confirmation (recommended for a personal app)

So you can log in instantly without clicking a confirmation email:

1. Go to **Authentication** → **Sign In / Providers** → **Email**.
2. Turn **off** "Confirm email" and save.

(If you'd rather leave it on, that's fine — you'll just click a link in a confirmation email the first time before signing in.)

## 4. Get your two keys

1. Go to **Project Settings** (gear icon) → **API**.
2. Copy these two values:
   - **Project URL** — looks like `https://abcdwxyz.supabase.co`
   - **anon public** key — a long string under "Project API keys"

> These two values are safe to put in the app's code. They're meant to be public — your data is protected by the security rules from step 2, not by hiding these keys.

## 5. Paste the keys into the app

1. Open **`main tracker.html`** in a text editor (right-click → Open with → Notepad / TextEdit / VS Code).
2. Near the top of the `<script>` section you'll see:

   ```js
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```

3. Replace the two placeholders with your real values (keep the quotes):

   ```js
   const SUPABASE_URL = 'https://abcdwxyz.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJhbGciOi....your-long-key....';
   ```

4. Save the file.

That's it. The app now syncs. Until those two values are filled in, the app just saves locally to one browser (so it always works either way).

---

## Try it

1. Open `main tracker.html` in your browser. You'll get a **Sign in** screen.
2. Type an email + password and click **Create account**, then **Sign in**.
3. Add or edit a transaction — watch the top say **Saving… → Synced**.
4. Open the file (or your deployed site) on another device or browser, sign in with the **same email and password** — your fund is there.

The status chip in the header shows **Synced / Saving… / Sync error**. Switching back to a tab or device pulls the latest automatically.

---

## Put it online (so you can reach it from anywhere)

To open it from your phone without copying the file around, deploy it to Vercel:

1. **Rename the file to `index.html`** (this makes it load at your site's root address).
2. Put it in its own folder, then either:
   - **Vercel CLI:** `npm i -g vercel`, then run `vercel` inside the folder and follow the prompts; `vercel --prod` to publish; or
   - **GitHub + Vercel:** push the folder to a GitHub repo, then on vercel.com choose **Add New → Project → Import** and **Deploy**.
3. Open the resulting URL on any device and sign in.

(Don't forget to do step 5 — paste your keys — before deploying.)

---

## Good to know

- **Privacy:** Each account can only read its own row (enforced by Supabase Row Level Security). Even though the URL/key are in the page, nobody can read your numbers without your email + password.
- **One login, many devices:** Sign in with the same details everywhere. It's the same shared data.
- **Backups still work:** The **Export** button still saves a JSON backup file anytime you want one.
- **Free limits:** Supabase's free tier (500 MB database, unlimited API requests) is far more than this app will ever use.

## Troubleshooting

- **Stuck on "Loading…" or "Sync error":** Re-check that the SQL in step 2 ran successfully and that your URL/key in step 5 are exact (no extra spaces, quotes intact).
- **"Email not confirmed" when signing in:** Either do step 3 (turn off Confirm email) or click the confirmation link Supabase emailed you, then sign in.
- **Header shows "Offline":** The Supabase library didn't load — check your internet connection.
- **Want to wipe a device's local copy:** Use the "⋯" button → type `clear`. This clears local data; your cloud data reloads next time you sign in.
