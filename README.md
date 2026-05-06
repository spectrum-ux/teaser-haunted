# 🕵️ Teaser Haunted

A self-contained treasure hunt web app. Players follow sequential clues, submit photo + location proof, and admins approve each step before the next clue unlocks.

**Live on GitHub Pages — no server, no build step, one HTML file.**

---

## 🗂 Repository contents

```
teaser-haunted/
├── index.html    ← The entire app (open this in any browser)
├── schema.sql    ← Run once in Supabase to set up the database
└── README.md     ← You are here
```

---

## 🚀 Part 1 — Set up Supabase (database + photo storage)

> Supabase is free. Setup takes ~5 minutes.

### 1.1 Create a Supabase project

1. Go to [supabase.com](https://supabase.com) → **Start your project** (free account)
2. Click **New project**
3. Choose a name (e.g. `teaser-haunted`) and a strong database password
4. Pick the region closest to your players (e.g. **Europe West**)
5. Wait ~2 minutes for the project to spin up

### 1.2 Run the database schema

1. In your Supabase project, click **SQL Editor** in the left sidebar
2. Click **New query**
3. Open `schema.sql` from this repo and paste the entire contents
4. Click **Run** (▶)

This creates:
- `settings` table — landing page title + intro text
- `clues` table — pre-seeded with all 6 clues
- `submissions` table — player photo + location submissions
- Storage bucket `submissions` — for uploaded photos
- Row Level Security policies

### 1.3 Get your Supabase credentials

1. In Supabase → **Settings** (gear icon) → **API**
2. Copy:
   - **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - **anon / public** key (long string starting with `eyJ…`)

### 1.4 Update credentials in `index.html`

Open `index.html` in any text editor and find these two lines near the top of the `<script>` block (around line 310):

```js
const SUPABASE_URL = 'https://tftoyulyuchzuphiykdk.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Replace the values with your own Project URL and anon key. Save the file.

---

## 🐙 Part 2 — Deploy to GitHub Pages

### 2.1 Create a GitHub repository

1. Go to [github.com](https://github.com) → **+** → **New repository**
2. Name it `teaser-haunted`
3. Set visibility to **Public** *(GitHub Pages requires Public on free accounts)*
4. Leave everything else as default → **Create repository**

### 2.2 Upload the files

**Option A — Browser (easiest, no git required):**

1. On the empty repo page, click **uploading an existing file**
2. Drag and drop both `index.html` and `README.md` onto the page
3. Scroll down → **Commit changes** → click the green button

**Option B — Git command line:**

```bash
cd /path/to/teaser-haunted
git init
git add index.html README.md schema.sql
git commit -m "Initial deploy"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/teaser-haunted.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

### 2.3 Enable GitHub Pages

1. In your GitHub repo → **Settings** tab
2. Scroll to **Pages** in the left sidebar
3. Under **Source** → select **Deploy from a branch**
4. Branch: **main** / Folder: **/ (root)** → **Save**
5. Wait ~60 seconds
6. Refresh the Settings → Pages page
7. You'll see: **Your site is live at `https://YOUR_USERNAME.github.io/teaser-haunted/`**

> ✅ That URL is your live app. Share it with players.

---

## 🔐 Admin access

Navigate to your live URL and click **🔐 Admin Login** at the bottom of the landing page.

| Field | Value |
|-------|-------|
| Email | `anupam1963@gmail.com` or `samiddhamukherjee@gmail.com` |
| Password | `yourpassword` |

**To change the password:** open `index.html`, find `const ADMIN_PASS = 'yourpassword';` and update it, then re-upload the file to GitHub.

**To add/change admin emails:** find `const ADMIN_EMAILS = [...]` and edit the list.

---

## 🎮 How the game works

| Step | What happens |
|------|-------------|
| Player visits the URL | Sees the landing page with the intro text |
| Clicks **ENTER** | Enters name + email (stored locally — no account created) |
| Game starts | Clue #1 is shown |
| Player solves clue → clicks **Finish** | Location is captured, photo is uploaded, **email app opens** with both admin emails pre-filled in To, location link + photo URL in body |
| Admin receives email | Opens admin dashboard, views location + photo, clicks **Approve** or **Reject** |
| Approved | Next clue unlocks automatically (page polls every 15 seconds) |
| All 6 clues done | Completion screen shown 🏆 |

---

## ✏️ Customising content

All content is editable live from the admin dashboard — no code changes needed:

- **Landing page** — title and intro text (Admin → Landing tab)
- **Clues** — add, edit, delete, reorder (Admin → Clues tab)

To change the clues permanently in the database, edit them in the admin panel. To change the *defaults* that get seeded, edit `schema.sql` before running it.

---

## 🔄 Updating the live site

Whenever you change `index.html`:

1. Go to your GitHub repo
2. Click on `index.html` → pencil icon (Edit) → paste updated content → **Commit changes**
   
   *Or via git:*
   ```bash
   git add index.html
   git commit -m "Update"
   git push
   ```

3. GitHub Pages rebuilds automatically in ~30 seconds

---

## ❓ Troubleshooting

| Problem | Fix |
|---------|-----|
| Blank page | Check browser console (F12) for errors. Most likely the Supabase URL/key is wrong. |
| "Failed to fetch" error | Re-check `SUPABASE_URL` and `SUPABASE_KEY` in `index.html`. Make sure there are no trailing spaces. |
| Photo upload fails | In Supabase → Storage → check the `submissions` bucket exists and is set to **Public** |
| Admin login fails | Password is case-sensitive. Check `ADMIN_PASS` in `index.html`. |
| Location says "unavailable" | Geolocation requires HTTPS. GitHub Pages serves HTTPS by default — opening `index.html` locally (file://) will block location. |
| Clues don't appear | Make sure you ran `schema.sql` in Supabase. Check the `clues` table has rows. |
| Submissions not appearing in admin | Check Supabase → `submissions` table. RLS policies must be enabled (schema.sql does this). |
