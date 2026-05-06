-- =====================================================
-- TREASURE HUNT — Supabase Schema (v3)
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. Settings (landing page content)
create table if not exists settings (
  id int primary key default 1,
  title text not null default 'The Grand Treasure Hunt',
  intro text not null default '',
  updated_at timestamptz default now()
);

insert into settings (id, title, intro) values (
  1,
  'The Grand Treasure Hunt',
  'Attention
For years, you have wandered separate paths —
one among satellites and distant orbits,
the other among molecules and unseen reactions.
Today, you begin a joint mission:
To retrace the steps that led you here.
Along the way, you will encounter fragments of your past —
some logical, some questionable, some best left unexplained.
Solve each clue, follow the path,
and you may yet reach the final destination.
Further instructions will follow.'
) on conflict (id) do update set
  title   = excluded.title,
  intro   = excluded.intro,
  updated_at = now();

-- 2. Clues
create table if not exists clues (
  id        uuid primary key default gen_random_uuid(),
  order_num int unique not null,
  title     text not null,
  description text not null,
  hint      text default '',
  created_at timestamptz default now()
);

insert into clues (order_num, title, description, hint) values
(1, 'Initial Conditions',
'Every system begins with an initial condition.
For this mission, it is not defined by coordinates,
but by a moment —
where curiosity, conversation, and coincidence aligned.
A first experiment was conducted there.',
''),
(2, 'Refuelling Station',
'Even the most advanced systems require fuel.
Before continuing, proceed to a nearby location
where energy is restored through
coffee, conversation, and baked goods.
You will need it.',
''),
(3, 'Flowing Paths',
'Constant motion leads to instability.
Even well-functioning systems require moments of balance.
Find the place where the city softens
and follow the path alongside flowing water
until you reach a crossing —
a place suited for reflection.',
''),
(4, 'The Uncontrolled Experiment',
'Not all experiments were controlled.
Records describe an evening involving
questionable samosas,
sounds produced by old televisions and radios,
and a rhythm that persisted far into the night.
Three individuals remained long after they should have left —
talking, laughing, and unknowingly closing a chapter
before the next one began.
Return to the site of this uncontrolled experiment.',
''),
(5, 'The Hobbits'' Place',
'During our time in deep south of the city,
the hobbits discovered a place that never quite made sense —
and yet, somehow, always did.
The food did not belong to one land,
the flavors travelled freely,
and still, the hobbits kept returning.
Not for certainty. Not for refinement.
But because it worked.
The hobbits must find this place again.',
''),
(6, '⚔️ Split Mission',
'⚠️ MISSION UPDATE ⚠️

Until now, you have operated as a team.
The next phase will test your ability
to navigate independently.
You must now separate.
Each of you has been assigned a different objective.
You will reunite only at the final destination.
Do not get lost.
Not with instruments, but with time.
Return to where your paths first crossed.',
'')
on conflict (order_num) do nothing;

-- 3. Submissions (no players table — anyone can play)
create table if not exists submissions (
  id           uuid primary key default gen_random_uuid(),
  player_name  text not null,
  player_email text not null,
  clue_id      uuid references clues(id) on delete cascade not null,
  status       text not null default 'pending'
               check (status in ('pending', 'approved', 'rejected')),
  location_lat double precision,
  location_lng double precision,
  photo_url    text,
  submitted_at timestamptz default now(),
  reviewed_at  timestamptz,
  unique(player_email, clue_id)
);

-- ── RLS ──────────────────────────────────────────────
alter table settings   enable row level security;
alter table clues       enable row level security;
alter table submissions enable row level security;

create policy "settings_read"   on settings    for select using (true);
create policy "settings_update" on settings    for update using (true);
create policy "clues_all"       on clues        for all    using (true);
create policy "submissions_all" on submissions  for all    using (true);

-- ── Storage (photo uploads) ───────────────────────────
insert into storage.buckets (id, name, public)
  values ('submissions', 'submissions', true) on conflict do nothing;
create policy "submissions_storage_insert" on storage.objects for insert
  with check (bucket_id = 'submissions');
create policy "submissions_storage_select" on storage.objects for select
  using (bucket_id = 'submissions');
