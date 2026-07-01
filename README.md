# Satpura GC App
### General Championship Tracker — BRCA & BSA
**Satpura Hostel · IIT Delhi**

---

## Table of Contents
1. [What This App Is](#1-what-this-app-is)
2. [BRCA Clubs & BSA Sports — Full List](#2-brca-clubs--bsa-sports--full-list)
3. [Complete Feature Set](#3-complete-feature-set)
4. [Roles & Permissions](#4-roles--permissions)
5. [Tech Stack — Every Layer Explained](#5-tech-stack--every-layer-explained)
6. [Database Design](#6-database-design)
7. [Will Firebase/Supabase Handle 500 Users?](#7-will-firebasesupabase-handle-500-users)
8. [How Role-Based Versions Work](#8-how-role-based-versions-work)
9. [What You Need to Learn](#9-what-you-need-to-learn)
10. [GitHub Repository Structure & Workflow](#10-github-repository-structure--workflow)
11. [Step-by-Step Build Plan](#11-step-by-step-build-plan)
12. [How to Divide Tasks Across a Team](#12-how-to-divide-tasks-across-a-team)

---

## 1. What This App Is

A single mobile app (Android + iOS) for Satpura hostel that tracks both the **BRCA Cultural Trophy** and the **BSA Sports General Championship** in one place. A toggle on the home screen switches between the two boards. Both sides share the same infrastructure — auth, notices, calendar, inventory, complaints, star performers, and memories — but the data (clubs vs sports, reps vs vice-captains) is scoped accordingly.

**Who uses it:** ~500 Satpura students, club/sport reps, and BRCA/BSA admins.

---

## 2. BRCA Clubs & BSA Sports — Full List

### BRCA Cultural Clubs (12 competitive + 1 non-competitive)

| # | Club Name | Full/Official Name | Competitive |
|---|---|---|---|
| 1 | Drama | Ankahi — Dramatics Club, IIT Delhi | ✅ Yes |
| 2 | Design | Design Club, IIT Delhi | ✅ Yes |
| 3 | PFC | Photography & Films Club (PFC) | ✅ Yes |
| 4 | FACC | Azure — Fine Arts & Crafts Club (FACC) | ✅ Yes |
| 5 | Dance | Dance Club, IIT Delhi (V-Defyn) | ✅ Yes |
| 6 | Hindi Samiti | Hindi Samiti, IIT Delhi | ✅ Yes |
| 7 | Literary | Literary Club (LitClub), IIT Delhi | ✅ Yes |
| 8 | DebSoc | Debating Club (DebSoc), IIT Delhi | ✅ Yes |
| 9 | QC | Quizzing Club (QC), IIT Delhi | ✅ Yes |
| 10 | Music | Music Club (Cadence), IIT Delhi | ✅ Yes |
| 11 | Envogue | Envogue — Fashion Club, IIT Delhi | ✅ Yes |
| 12 | Spic Macay | Spic Macay, IIT Delhi Chapter | ❌ Non-competitive |

### BSA Sports (14 sports, all competitive)

| # | Sport |
|---|---|
| 1 | Athletics |
| 2 | Badminton |
| 3 | Basketball |
| 4 | Chess |
| 5 | Cricket |
| 6 | Football |
| 7 | Hockey |
| 8 | Lawn Tennis |
| 9 | Squash |
| 10 | Swimming |
| 11 | Table Tennis |
| 12 | Volleyball |
| 13 | Water Polo |
| 14 | Weightlifting |

---

## 3. Complete Feature Set

Both BRCA and BSA sides share the same features. Where the implementation differs, it is noted.

### 3.1 Board Toggle
- A prominent toggle on the home screen switches between BRCA (cultural) and BSA (sports).
- The entire app — leaderboard, calendar, notices, everything — switches context.
- The toggle state is remembered per session.

### 3.2 Leaderboard
- **Overall view:** total points across all clubs/sports, all hostels ranked.
- **Club/sport-wise view:** filter by one club or sport, see per-hostel ranking.
- Transparent scoring: points awarded + deductions shown separately, never silently netted.
- Satpura's row is highlighted in every view.

### 3.3 Interactive Calendar
- Month-grid view. Events can span multiple days (start date + end date).
- Each cell shows compact pills for that day's events with start/ongoing/end markers.
- Tap a date → list of events that day → tap one → full detail (time, venue, points, rulebook PDF, registration action).
- Hostel-level workshops appear as read-only calendar entries (sourced from notices).
- **Registration counter on event detail:** shows "X of Y spots filled" so reps can see participation and push engagement if numbers are low.

### 3.4 Registration & Participation Tracking
- Two modes per event:
  - **External form link** — app opens the Google Form and records when a student tapped "Register."
  - **In-app notify** — no link, shows "contact your rep."
- **Participation counter visible to reps and admins:** number registered vs capacity. If below a threshold (e.g. < 50% of capacity), reps get an automatic in-app alert to engage more people.
- Students can see total registrations but not individual names (privacy).
- Reps and admins see full registration list.

### 3.5 Notices
- Scoped: institute-wide / hostel-specific / club or sport-specific.
- Categorized: info / registration / results / alert / rule change.
- Pinned notices surface first.
- Optional event date/time on a notice — makes it appear on the calendar as a read-only entry.
- Push notifications on new notices, scoped to who it's relevant for.

### 3.6 Scores & Deductions
- Reps/vice-captains submit score claims after an event.
- Admin verifies before it reflects on the live leaderboard.
- Deductions (post-contention-meet, rule violations, etc.) flagged by reps, confirmed by admin.
- Fixed appeal window (e.g. 48 hours) before a score locks.
- Full audit trail: submitted by, verified by, timestamp.

### 3.7 Inventory
- Per club/sport per hostel: item name, quantity, condition, checked-out to, last updated by.
- Reps can only edit their own club/sport's inventory.
- Low-stock flagging.

### 3.8 Complaints & Queries
- Categories: rep/vice-captain performance, management issue, general query.
- Anonymous to the person being complained about — visible to admin only (enforced at database level, not just UI).
- Status tracking: open → in review → resolved.

### 3.9 Star Performer of the Month ⭐ (NEW)
- Admin nominates 1-3 students per month (one for BRCA, one for BSA, optionally one per club/sport).
- Shown on a dedicated "Wall of Fame" card on the home screen.
- Includes student name, photo (uploaded by admin), achievement description, and month.
- Historical archive: all past star performers browsable.

### 3.10 Memories & Achievements Gallery 📸 (NEW)
- Admins or reps can post a "memory" — a title, description, and a **Google Drive folder link** or **direct photo upload**.
- Tagged by club/sport and year, so it builds into a searchable archive over seasons.
- Categories: competition win, cultural performance, milestone, throwback.
- Students can browse the gallery by club/sport or year.
- This is not a full social feed — no likes, no comments. It is a curated archive, moderated by reps and admins.

### 3.11 Notification Preferences (NEW)
- Students can mute clubs or sports they don't follow.
- Muting a club removes its notices and calendar events from the student's default view (they can still browse manually).

### 3.12 Admin Activity Log (NEW)
- Every score update, deduction, notice post, and user role change is logged with who did it and when.
- Visible only to admin. Prevents silent overwrites when multiple admins operate simultaneously.

### 3.13 Analytics Dashboard for Admin (NEW)
- Events with lowest registration rates (participation health).
- Which clubs/sports have outstanding unverified score claims.
- Inventory items flagged as missing or poor condition.
- Star performer history.
- Exportable as CSV for end-of-season handover.

### 3.14 Season-End Export (NEW)
- Admin can generate a full season summary: final standings, event history, star performers, inventory state.
- Downloads as PDF or CSV. Used for institute records and handover to next year's team.

---

## 4. Roles & Permissions

### BRCA Side

| Role | Who | Scoped To | Permissions |
|---|---|---|---|
| **Student** | All Satpura students | Read-only | View leaderboard, calendar, notices, gallery. Register for events. Raise complaints. |
| **Club Rep** | One per club in Satpura | One club | Submit scores/deductions, manage club inventory, post club notices, view registration list for their club's events. |
| **BRCA Admin** | BRCA organizing team | All | Everything — create/edit events, verify scores, manage users, post any notice, resolve complaints, nominate star performers, manage gallery. |

### BSA Side

| Role | Who | Scoped To | Permissions |
|---|---|---|---|
| **Student** | All Satpura students | Read-only | Same as BRCA student. |
| **Vice Captain** | One per sport in Satpura | One sport | Same as Club Rep but for their sport. |
| **BSA Admin** | BSA organizing team | All | Same as BRCA Admin but for BSA. |

> One student can hold multiple roles — e.g. they can be a Club Rep for Dance (BRCA) and a Vice Captain for Cricket (BSA) simultaneously. The app handles this: their profile shows all their active roles, and they see the relevant rep tools for each.

---

