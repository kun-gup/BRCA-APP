-- ============================================================
-- 001_initial_schema.sql
-- Base schema up to deductions.
-- ============================================================

create table hostels (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  short_code text not null unique
);

create table boards (
  id uuid primary key default gen_random_uuid(),
  name text not null unique
);

create table activities (
  id uuid primary key default gen_random_uuid(),
  board_id uuid not null references boards(id) on delete cascade,
  name text not null,
  full_name text,
  is_competitive boolean not null default true,
  logo_url text
);

create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  entry_number text not null unique,
  name text not null,
  role text not null default 'student'
    check (role in ('student', 'rep', 'vice_captain', 'admin')),
  hostel_id uuid references hostels(id),
  created_at timestamptz not null default now()
);

create table user_activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles(id) on delete cascade,
  activity_id uuid not null references activities(id) on delete cascade,
  hostel_id uuid not null references hostels(id),
  unique (user_id, activity_id)
);

create table events (
  id uuid primary key default gen_random_uuid(),
  activity_id uuid not null references activities(id) on delete cascade,
  title text not null,
  type text not null default 'competitive'
    check (type in ('competitive', 'non_competitive', 'institute_workshop')),
  audience text not null default 'all'
    check (audience in ('all', 'freshers_only')),
  start_date date not null,
  end_date date not null,
  time time,
  venue text,
  points integer default 0,
  rulebook_url text,
  registration_type text not null default 'notify_only'
    check (registration_type in ('external_link', 'notify_only')),
  registration_link text,
  max_participants integer,
  status text not null default 'upcoming'
    check (status in ('upcoming', 'ongoing', 'completed', 'cancelled')),
  season text,
  created_by uuid references profiles(id),
  created_at timestamptz not null default now()
);

create table registrations (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references events(id) on delete cascade,
  user_id uuid not null references profiles(id) on delete cascade,
  hostel_id uuid not null references hostels(id),
  registered_at timestamptz not null default now(),
  unique (event_id, user_id)
);

create table scores (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references events(id) on delete cascade,
  hostel_id uuid not null references hostels(id),
  points_awarded numeric not null default 0,
  status text not null default 'pending'
    check (status in ('pending', 'verified', 'contested')),
  submitted_by uuid references profiles(id),
  verified_by uuid references profiles(id),
  appeal_deadline timestamptz,
  created_at timestamptz not null default now()
);

create table deductions (
  id uuid primary key default gen_random_uuid(),
  hostel_id uuid not null references hostels(id),
  activity_id uuid not null references activities(id),
  reason text not null,
  points_deducted numeric not null default 0,
  flagged_by uuid references profiles(id),
  confirmed_by uuid references profiles(id),
  status text not null default 'flagged'
    check (status in ('flagged', 'confirmed', 'rejected')),
  created_at timestamptz not null default now()
);

create index idx_scores_hostel on scores(hostel_id);
create index idx_scores_event on scores(event_id);
create index idx_events_activity on events(activity_id);
create index idx_events_dates on events(start_date, end_date);
create index idx_user_activities_user on user_activities(user_id);
create index idx_registrations_event on registrations(event_id);
