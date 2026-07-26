-- Raahnuma: Punjab Community Supervision System
-- Supabase Fictional Demonstration Seed Data
-- Location: docs/backend/supabase_seed_demo.sql

-- Clear existing fictional data (in correct dependency order)
TRUNCATE public.activities CASCADE;
TRUNCATE public.alerts CASCADE;
TRUNCATE public.contacts CASCADE;
TRUNCATE public.checkins CASCADE;
TRUNCATE public.appointments CASCADE;
TRUNCATE public.supervisees CASCADE;
TRUNCATE public.officers CASCADE;
TRUNCATE public.profiles CASCADE;

-- 1. SEED AUTH USERS (Fictional credentials for local development/testing)
-- Static UUID definitions:
-- Admin:    '00000000-0000-0000-0000-000000000000'
-- Officer:  'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d'
-- Supervisee: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f'

INSERT INTO auth.users (id, email, raw_user_meta_data, created_at, role, aud, encrypted_password)
VALUES 
  ('00000000-0000-0000-0000-000000000000', 'admin.raahnuma@example.com', '{"full_name": "DG Office Admin"}'::jsonb, now(), 'authenticated', 'authenticated', crypt('AdminPassword123', gen_salt('bf'))),
  ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'officer.tahir@example.com', '{"full_name": "Tahir Mahmood"}'::jsonb, now(), 'authenticated', 'authenticated', crypt('OfficerPassword123', gen_salt('bf'))),
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'supervisee.tariq@example.com', '{"full_name": "Tariq Mehmood"}'::jsonb, now(), 'authenticated', 'authenticated', crypt('SuperviseePassword123', gen_salt('bf')))
ON CONFLICT (id) DO NOTHING;

-- 2. SEED PROFILES
INSERT INTO public.profiles (id, email, full_name, role, updated_at, created_at)
VALUES
  ('00000000-0000-0000-0000-000000000000', 'admin.raahnuma@example.com', 'DG Office Admin', 'administrator', now(), now()),
  ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'officer.tahir@example.com', 'Tahir Mahmood', 'officer', now(), now()),
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'supervisee.tariq@example.com', 'Tariq Mehmood', 'supervisee', now(), now());

-- 3. SEED OFFICERS
INSERT INTO public.officers (id, designation, district, office_address, badge_number, status, created_at)
VALUES
  ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Probation Officer', 'Lahore', 'Lahore Central Office, Home Department, Lahore', 'PO-589', 'Active', now());

-- 4. SEED SUPERVISEES
INSERT INTO public.supervisees (id, cnic_masked, case_number, supervision_category, assigned_officer_id, next_reporting_date, supervision_start_date, supervision_end_date, compliance_status, created_at)
VALUES
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', '35201-XXXXXXX-9', 'LHR-2026-089', 'Probation Order', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', '2026-07-28', '2026-06-15', '2026-12-15', 'Compliant', now());

-- 5. SEED APPOINTMENTS
INSERT INTO public.appointments (supervisee_id, officer_id, title, scheduled_time, location, status, created_at)
VALUES
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Initial Assessment / ابتدائی جائزہ', '2026-06-15 11:30:00+05', 'Lahore Central Office', 'Completed', now()),
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Office Reporting / دفتری حاضری', '2026-07-28 10:00:00+05', 'Lahore Central Office', 'Upcoming', now());

-- 6. SEED CHECKINS
INSERT INTO public.checkins (supervisee_id, scheduled_reporting_date, receipt_number, identity_confirmed, residing_at_address, changed_employment, need_assistance, complying_conditions, submitted_at)
VALUES
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', '2026-07-25', 'PPPS-CI-2026-8941', TRUE, TRUE, FALSE, FALSE, TRUE, now() - INTERVAL '1 day');

-- 7. SEED CONTACTS
INSERT INTO public.contacts (supervisee_id, officer_id, contact_type, contact_date, notes, outcome, created_at)
VALUES
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Office Visit', '2026-06-15', 'Initial assessment interview conducted. Supervisee agreed to probation guidelines.', 'Satisfactory', now() - INTERVAL '40 days'),
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Digital Check-In Review', '2026-07-25', 'Checked submitted digital report. Declared address is stable. Approved check-in status.', 'Satisfactory', now() - INTERVAL '1 day');

-- 8. SEED ALERTS
INSERT INTO public.alerts (supervisee_id, category, severity, description, status, resolved_at, resolved_by, resolution_notes, created_at)
VALUES
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'Missed Check-In', 'Overdue', 'Check-In report overdue for regional sector reporting date.', 'Resolved', now() - INTERVAL '2 days', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Supervisee reported offline checkin, verification completed physically.', now() - INTERVAL '3 days'),
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'Missed Appointment', 'Pending Review', 'Officer Tahir Mahmood flagged brief reporting time deviation.', 'Active', NULL, NULL, NULL, now() - INTERVAL '1 hour');

-- 9. SEED ACTIVITIES (System events)
INSERT INTO public.activities (actor_id, event_type, description, ip_address, user_agent, integrity_hash, created_at)
VALUES
  ('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'SUPERVISEE_CHECKIN', 'Digital check-in submitted from mobile portal.', '192.168.1.10', 'Mozilla/5.0 Android', 'sha256:5ef2db3c48ea92a95c960c1d1d0f5e6a', now() - INTERVAL '1 day'),
  ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'OFFICER_REVIEW', 'Reviewed check-in submission for Tariq Mehmood.', '192.168.1.5', 'Mozilla/5.0 Windows', 'sha256:9cf2ab3d48ef92b95c960c1d1d0f5e7b', now() - INTERVAL '12 hours');
