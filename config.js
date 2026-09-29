// ─────────────────────────────────────────────────────────────────────────────
//  Supabase connection for the Internationals Good Boy Ranking board
//
//  Paste your two values between the quotes below, then save the file.
//  Where to find them in Supabase: open your project → click "Connect" at the
//  top of the page (or Project Settings → API Keys).
//
//  ✅ Use the PUBLIC key: labelled "anon public" or "Publishable key"
//     (starts with "eyJ..." or "sb_publishable_...").
//  ❌ NEVER paste the "service_role" or "Secret key" (starts with "sb_secret_...").
//     The page refuses to run with it, but keep it out of this file anyway.
//
//  Both values below are meant to be public. The database rules in
//  supabase-setup.sql are what stop visitors from doing anything except
//  moving the six pegs.
// ─────────────────────────────────────────────────────────────────────────────

window.RANKING_CONFIG = {
  supabaseUrl: "https://ibxakkwlckdnmrgudhox.supabase.co",
  supabaseAnonKey: "sb_publishable_Rz_sZ8Y568NZOOFM-roQsA_UTtXS55n",
};
