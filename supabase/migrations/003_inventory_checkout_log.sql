-- ============================================================
-- 003_inventory_checkout_log.sql
-- ============================================================

alter table inventory_items drop column if exists checked_out_to;

create table inventory_checkouts (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references inventory_items(id) on delete cascade,
  issued_by uuid not null references profiles(id),
  borrower_name text not null,
  borrower_entry_number text not null,
  borrower_phone text not null,
  issued_at timestamptz not null default now(),
  expected_return_at date,
  returned_at timestamptz,
  returned_condition text
    check (returned_condition in ('good', 'fair', 'poor', 'damaged', 'lost')),
  notes text
);

create index idx_checkouts_item on inventory_checkouts(item_id);
create index idx_checkouts_open on inventory_checkouts(item_id) where returned_at is null;

create view inventory_current_status
with (security_invoker = true) as
select
  i.id as item_id,
  i.item_name,
  i.activity_id,
  i.hostel_id,
  i.quantity,
  i.condition,
  c.borrower_name,
  c.borrower_entry_number,
  c.borrower_phone,
  c.issued_at,
  c.expected_return_at
from inventory_items i
left join lateral (
  select * from inventory_checkouts
  where item_id = i.id and returned_at is null
  order by issued_at desc
  limit 1
) c on true;
