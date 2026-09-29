-- ═══════════════════════════════════════════════════════════════════════════
--  Internationals Good Boy Ranking: database setup
--
--  How to use: Supabase → SQL Editor → New query → paste ALL of this → Run.
--  It's safe to run more than once.
-- ═══════════════════════════════════════════════════════════════════════════

-- 1. The table: one row per person. position 0 = top of the board, 1 = bottom.
create table if not exists public.rankings (
  name        text primary key,
  position    double precision not null default 0.5
              check (position >= 0 and position <= 1),
  updated_at  timestamptz not null default now()
);

-- 2. The database stamps the time of every change itself,
--    so the newest move always wins, whatever a phone's clock says.
create or replace function public.rankings_touch()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists rankings_touch on public.rankings;
create trigger rankings_touch
  before update on public.rankings
  for each row execute function public.rankings_touch();

-- 3. The six people and their starting spots (same as the Reset button).
insert into public.rankings (name, position) values
  ('Aleks',   0.08),
  ('Jacob',   0.215),
  ('Matthew', 0.365),
  ('John',    0.5),
  ('Alfie',   0.62),
  ('Moya',    0.69)
on conflict (name) do nothing;

-- 4. Permissions: anyone with the website (no login) can READ the board
--    and MOVE the pegs. Nobody can add, rename or delete people from the site.
alter table public.rankings enable row level security;

drop policy if exists "Anyone can read the board" on public.rankings;
create policy "Anyone can read the board"
  on public.rankings for select
  to anon, authenticated
  using (true);

drop policy if exists "Anyone can move a peg" on public.rankings;
create policy "Anyone can move a peg"
  on public.rankings for update
  to anon, authenticated
  using (true)
  with check (true);

revoke insert, update, delete, truncate on public.rankings from anon, authenticated;
grant select on public.rankings to anon, authenticated;
grant update (position) on public.rankings to anon, authenticated;

-- 5. Realtime: send every change to everyone who has the page open.
do $$
begin
  alter publication supabase_realtime add table public.rankings;
exception
  when duplicate_object then null;  -- already enabled
end;
$$;

-- Done. Check it worked: this should list the six names.
select name, position, updated_at from public.rankings order by position;
