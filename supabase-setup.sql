-- ============================================================
--  Fund Tracker  —  Supabase database setup
--  Run ONCE:  Supabase dashboard ->  SQL Editor ->  New query
--             paste everything below ->  Run.
--  Safe to re-run (it won't duplicate anything).
-- ============================================================

-- 1) One row per user stores the entire fund as JSON.
create table if not exists public.funds (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 2) Row Level Security: lock the table so each person can only
--    ever see or change their own row.
alter table public.funds enable row level security;

-- 3) Policies — a signed-in user may read/insert/update ONLY their own row.
drop policy if exists "own_select" on public.funds;
drop policy if exists "own_insert" on public.funds;
drop policy if exists "own_update" on public.funds;

create policy "own_select" on public.funds
  for select using (auth.uid() = user_id);

create policy "own_insert" on public.funds
  for insert with check (auth.uid() = user_id);

create policy "own_update" on public.funds
  for update using (auth.uid() = user_id)
              with check (auth.uid() = user_id);

-- Done. Next: copy your Project URL + anon key into the app's CONFIG block.
