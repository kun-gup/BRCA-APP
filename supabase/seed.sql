-- ============================================================
-- seed.sql
-- Populates static reference data.
-- ============================================================

insert into hostels (name, short_code) values
  ('Aravali', 'ARA'), ('Girnar', 'GIR'), ('Himadri', 'HIM'),
  ('Jwalamukhi', 'JWL'), ('Kailash', 'KAL'), ('Karakoram', 'KAR'),
  ('Kumaon', 'KUM'), ('Nilgiri', 'NIL'), ('Satpura', 'SAT'),
  ('Shivalik', 'SHV'), ('Udaigiri', 'UDA'), ('Vindhyachal', 'VIN'),
  ('Zanskar', 'ZAN'), ('Dronagiri', 'DRO'), ('Saptagiri', 'SAP'),
  ('Sahyadri', 'SAH');

insert into boards (name) values ('BRCA'), ('BSA');

insert into activities (board_id, name, full_name, is_competitive)
select id, v.name, v.full_name, v.is_competitive
from boards, (values
  ('Drama', 'Dramatics Club', true),
  ('Design', 'Design Club', true),
  ('PFC', 'Photography & Films Club', true),
  ('FACC', 'Fine Arts & Crafts Club', true),
  ('Dance', 'Dance Club', true),
  ('Hindi Samiti', 'Hindi Samiti', true),
  ('Literary', 'Literary Club', true),
  ('DebSoc', 'Debating Club', true),
  ('QC', 'Quizzing Club', true),
  ('Music', 'Music Club', true),
  ('Envogue', 'Fashion Club', true),
  ('Spic Macay', 'Spic Macay', false)
) as v(name, full_name, is_competitive)
where boards.name = 'BRCA';

insert into activities (board_id, name, full_name, is_competitive)
select id, v.name, v.name, true
from boards, (values
  ('Athletics'), ('Badminton'), ('Basketball'), ('Chess'),
  ('Cricket'), ('Football'), ('Hockey'), ('Lawn Tennis'),
  ('Squash'), ('Swimming'), ('Table Tennis'), ('Volleyball'),
  ('Water Polo'), ('Weightlifting')
) as v(name)
where boards.name = 'BSA';
