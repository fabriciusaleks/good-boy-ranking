# Internationals Good Boy Ranking

A shared ranking board. Everyone who opens the link sees the same board and can drag the pegs. Moves show up on everyone's screen straight away.

## What's in this folder

| File | What it is |
|---|---|
| `index.html` | The website. You don't need to edit it. |
| `config.js` | Where you paste your Supabase URL and public key. |
| `supabase-setup.sql` | Creates the database table, the six names, the permissions and live updates. You paste it into Supabase once. |
| `README.md` | These instructions. |

---

## 1. Create the Supabase project

1. Go to **https://supabase.com** and click **Start your project**. Sign up (GitHub or email is fine).
2. Click **New project**.
3. Pick your organization (Supabase makes one for you on sign-up).
4. Fill in:
   - **Project name:** `good-boy-ranking`
   - **Database password:** click **Generate a password** and save it somewhere. The website doesn't need it.
   - **Region:** the one closest to where you and your friends are.
5. Click **Create new project** and wait 1–2 minutes until the dashboard finishes loading.

## 2–5. Create the table, add the six names, turn on Realtime, set permissions

All four steps are done by one script.

1. In the left sidebar, click **SQL Editor**.
2. Click **+ New query** (or use the empty editor that opens).
3. Open `supabase-setup.sql` from this folder in a text editor (Notepad, TextEdit), select everything, copy it, and paste it into the Supabase editor.
4. Click **Run** (bottom right), or press Ctrl+Enter / Cmd+Enter.
5. If a box warns about a **destructive operation**, click **Run this query**. That warning appears because the script safely replaces its own rules if you run it twice.
6. At the bottom you should see a table with the six names: Aleks, Jacob, Matthew, John, Alfie, Moya.

What the script did:
- **Table:** created `rankings` with `name` (unique), `position` (0 = top of the board, 1 = bottom) and `updated_at`.
- **Names:** inserted the six people at their starting spots.
- **Permissions:** anyone without logging in can **read** the board and **change a position**, and nothing else. Visitors can't add, rename or delete people.
- **Realtime:** switched it on for the `rankings` table so changes are pushed to everyone.

**Optional check that Realtime is on:** left sidebar → **Database** → **Publications** → click **supabase_realtime** (or the table count next to it). `rankings` should be switched on.

## 6. Put your Supabase URL and public key into `config.js`

1. In Supabase, click the **Connect** button at the top of your project. If you don't see it, go to **Project Settings** (gear icon) → **API Keys**. The Project URL is also under **Project Settings → Data API**.
2. Copy the **Project URL**. It looks like `https://abcdefghijkl.supabase.co`.
3. Copy the **public** key. Supabase shows it as **Publishable key** (starts with `sb_publishable_`) or, on the "Legacy API keys" tab, **anon public** (a long key starting with `eyJ`). Either one works.
4. Open `config.js` in a text editor and replace the two placeholder values:

   ```js
   window.RANKING_CONFIG = {
     supabaseUrl: "https://abcdefghijkl.supabase.co",
     supabaseAnonKey: "sb_publishable_xxxxxxxxxxxxxxxx",
   };
   ```

5. Save the file.

> **Never** paste the **service_role** key or a **Secret key** (starts with `sb_secret_`). Those are admin keys. The page refuses to run with one and shows a warning. The public key is designed to be visible in a website. The rules from step 2–5 are what protect the data.

## 7. Run and test it on your computer

1. Double-click `index.html`. It opens in your browser.
2. Under the board you should see a green dot and **Live**. If it says something else, see *Troubleshooting* below.
3. Open the same file in a second window, for example a private/incognito window, and put the two windows side by side.
4. Drag a peg in one window. The other window shows it moving while you drag, and it settles where you drop it.
5. Click **Reset rankings** in one window. Both windows reset.
6. Optional: in Supabase, open **Table Editor** → `rankings` and refresh. The `position` values change as you move pegs.

Your phone can't open a file on your computer, so test phones after deploying (step 8).

## 8. Put it online with Vercel

Vercel publishes from GitHub, so first put the files on GitHub. No terminal needed.

**A. Upload the files to GitHub**
1. Go to **https://github.com** and create a free account (or log in).
2. Click **+** (top right) → **New repository**.
3. **Repository name:** `good-boy-ranking`. Public or Private both work. Click **Create repository**.
4. On the next page click the link **uploading an existing file**.
5. Drag in `index.html`, `config.js` (with your values filled in), `supabase-setup.sql` and `README.md`.
6. Click **Commit changes**.

**B. Deploy on Vercel**
1. Go to **https://vercel.com** → **Sign Up** → choose **Hobby** (free) → **Continue with GitHub** and approve the access request.
2. On the dashboard click **Add New…** → **Project**.
3. Find `good-boy-ranking` and click **Import**. If it's not listed, click **Adjust GitHub App Permissions** and give Vercel access to that repository.
4. Leave the settings as they are: **Framework Preset: Other**, **Root Directory: ./**, no build command. Click **Deploy**.
5. Wait about 30 seconds and click **Continue to Dashboard**. Under **Domains** you'll see an address like `good-boy-ranking.vercel.app`. That's the link to send to your friends.

> Share the short address under **Domains**. The long, random-looking deployment addresses can ask visitors to log in to Vercel.

**Changing something later:** edit or re-upload the file on GitHub. Vercel updates the site automatically within a minute.

---

## Troubleshooting

| The status line says | What to do |
|---|---|
| "Not connected yet…" | `config.js` still has the placeholder values, or the file wasn't uploaded next to `index.html`. |
| "config.js contains a secret admin key…" | You pasted the service_role / secret key. Replace it with the anon / publishable key. |
| "The database is missing …" | The six names aren't in the table. Run `supabase-setup.sql` again. |
| "Couldn't reach the database. Retrying…" | Check the Project URL in `config.js`. If the project was paused for inactivity, open it in Supabase and click **Restore**. Free projects pause after about a week without use. |
| Stuck on "Connecting…" but pegs load | Realtime isn't reaching the page. In Supabase → **Project Settings** → **Realtime**, make sure public access to channels is allowed (the private-only option should be off). Then check the publication step in section 2–5. |
| "Couldn't save your last move. Retrying…" | Usually the permissions weren't created. Run `supabase-setup.sql` again. |

## How it handles several people at once

- **Saving:** a peg's position is saved the moment you let go. The newest move wins, using the database's own clock, so phone clocks don't matter.
- **Live dragging:** friends see a peg move while you're dragging it. If your connection drops mid-drag, their screens settle back to the last saved spot.
- **Same peg, same time:** if two people grab the same peg, whoever lets go last decides where it ends up. Everyone's screen then agrees.
- **Offline:** if you lose signal, your move is kept on your phone and saved as soon as you're back online.
- **Phones in the background:** the board catches up when you come back to the page.
- **Security trade-off:** with no login, anyone who has the link can move pegs. They can't do anything else to the database.
