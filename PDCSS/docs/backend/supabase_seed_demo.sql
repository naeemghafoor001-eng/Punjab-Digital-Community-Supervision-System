-- Raahnuma: Punjab Community Supervision System
-- Supabase Fictional Demonstration Seed Data
-- Location: docs/backend/supabase_seed_demo.sql

-- Clear existing fictional data (in correct dependency order)
TRUNCATE public.activity_attendance CASCADE;
TRUNCATE public.assigned_activities CASCADE;
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

-- 10. SEED ASSIGNED ACTIVITIES
INSERT INTO public.assigned_activities (
  id, supervisee_id, officer_id, activity_title, activity_category, instructions, frequency, due_time, start_date, end_date, status, expected_location_name, expected_latitude, expected_longitude, allowed_radius_meters, requires_location, requires_photo, requires_liveness, created_at
) VALUES
  ('11111111-1111-1111-1111-111111111111', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Bi-weekly Probation Office Reporting', 'Reporting', 'Report to Lahore Central Office for bi-weekly progress review.', 'Bi-Weekly', '10:00:00', '2026-06-15', '2026-12-15', 'Active', 'Lahore Central Office', 31.5601, 74.3352, 300, TRUE, TRUE, TRUE, now() - INTERVAL '30 days'),
  ('22222222-2222-2222-2222-222222222222', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'TEVTA Vocational Skills Workshop', 'Skills', 'Attend vocational electrician training sessions at TEVTA center.', 'Weekly', '14:00:00', '2026-07-01', '2026-09-30', 'Active', 'TEVTA Vocational Center Lahore', 31.5204, 74.3587, 400, TRUE, TRUE, FALSE, now() - INTERVAL '25 days'),
  ('33333333-3333-3333-3333-333333333333', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Community Welfare Cleanliness Drive', 'Community Service', 'Participate in approved civic community service activity.', 'Weekly', '09:00:00', '2026-07-05', '2026-08-30', 'Active', 'Model Town Community Park', 31.4822, 74.3211, 500, TRUE, FALSE, FALSE, now() - INTERVAL '20 days'),
  ('44444444-4444-4444-4444-444444444444', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Rehabilitation & Wellness Counselling', 'Counselling', 'Participate in guidance and counselling session with designated officer.', 'Monthly', '11:00:00', '2026-06-20', '2026-12-20', 'Active', 'District Probation Guidance Center', 31.5601, 74.3352, 300, TRUE, TRUE, TRUE, now() - INTERVAL '15 days'),
  ('55555555-5555-5555-5555-555555555555', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Spiritual / Personal Discipline Activity', 'Personal Discipline', 'Voluntary personal discipline activity as part of approved rehabilitation plan.', 'Daily', '08:00:00', '2026-07-01', '2026-12-31', 'Active', 'Local Designated Center', NULL, NULL, 500, FALSE, FALSE, FALSE, now() - INTERVAL '10 days');

-- 11. SEED ACTIVITY ATTENDANCE SUBMISSIONS
INSERT INTO public.activity_attendance (
  assigned_activity_id, supervisee_id, officer_id, submitted_at, attendance_status, latitude, longitude, accuracy_meters, location_captured_at, location_permission_status, expected_latitude, expected_longitude, distance_from_expected_meters, allowed_radius_meters, location_match_status, photo_url, photo_status, liveness_status, remarks, review_status, receipt_no, reviewed_by, reviewed_at, created_at
) VALUES
  ('11111111-1111-1111-1111-111111111111', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', now() - INTERVAL '2 days', 'Submitted', 31.5602, 74.3351, 8.5, now() - INTERVAL '2 days', 'Granted', 31.5601, 74.3352, 18.2, 300, 'Within Radius', 'https://whqmwzoqmopgamfacncg.supabase.co/storage/v1/object/public/attendance-photos/demo_photo_1.jpg', 'Uploaded', 'Prompt Completed', 'Arrived on time at Lahore office.', 'Accepted', 'PPPS-VA-2026-1042', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', now() - INTERVAL '1 day', now() - INTERVAL '2 days'),
  ('22222222-2222-2222-2222-222222222222', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', now() - INTERVAL '5 hours', 'Submitted', 31.5208, 74.3582, 12.0, now() - INTERVAL '5 hours', 'Granted', 31.5204, 74.3587, 65.4, 400, 'Within Radius', 'https://whqmwzoqmopgamfacncg.supabase.co/storage/v1/object/public/attendance-photos/demo_photo_2.jpg', 'Uploaded', 'Not Required', 'Attended TEVTA practical class.', 'Pending Review', 'PPPS-VA-2026-3891', NULL, NULL, now() - INTERVAL '5 hours'),
  ('33333333-3333-3333-3333-333333333333', 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', now() - INTERVAL '1 day', 'Late', 31.4890, 74.3290, 25.0, now() - INTERVAL '1 day', 'Granted', 31.4822, 74.3211, 1050.8, 500, 'Outside Radius', NULL, 'Not Required', 'Not Required', 'Submitted location while travelling near site.', 'Needs Follow-up', 'PPPS-VA-2026-7723', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', now() - INTERVAL '4 hours', now() - INTERVAL '1 day');

