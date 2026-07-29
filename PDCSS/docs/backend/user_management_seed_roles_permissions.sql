-- Raahnuma: Punjab Community Supervision System
-- Seed Roles and Permissions for RBAC Matrix
-- Location: docs/backend/user_management_seed_roles_permissions.sql

-- Clear existing seed data safely
TRUNCATE public.user_activity_audit_logs CASCADE;
TRUNCATE public.login_audit_logs CASCADE;
TRUNCATE public.user_office_access CASCADE;
TRUNCATE public.user_division_access CASCADE;
TRUNCATE public.user_district_access CASCADE;
TRUNCATE public.user_roles CASCADE;
TRUNCATE public.role_permissions CASCADE;
TRUNCATE public.permissions CASCADE;
TRUNCATE public.roles CASCADE;

-- 1. SEED DEFAULT SYSTEM ROLES
INSERT INTO public.roles (id, role_code, role_name, role_description, role_level, is_system_role, is_active) VALUES
  ('11111111-0000-0000-0000-000000000001', 'super_admin', 'Super Administrator', 'Full unrestricted system administration authority.', 100, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000002', 'system_admin', 'System Administrator', 'User management, RBAC, and system configuration admin.', 90, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000003', 'directorate_general', 'Directorate General Officer', 'Provincial oversight, analytics, and policy monitoring.', 80, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000004', 'divisional_admin', 'Divisional Administrator', 'Divisional monitoring, officer supervision, and audits.', 70, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000005', 'district_admin', 'District Administrator', 'District probation officer supervision and case plan approvals.', 60, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000006', 'supervisory_officer', 'Supervisory Officer', 'Case reviews, field visit supervision, and attendance checks.', 50, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000007', 'probation_officer', 'Probation Officer', 'Direct supervision, PRNA assessments, case planning, and visits.', 40, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000008', 'parole_officer', 'Parole Officer', 'Parolee supervision, compliance checks, and rehab tracking.', 40, TRUE, TRUE),
  ('11111111-0000-0000-0000-000000000009', 'data_entry_operator', 'Data Entry Operator', 'OMIS data import and initial record verification.', 30, FALSE, TRUE),
  ('11111111-0000-0000-0000-000000000010', 'read_only_viewer', 'Read-Only Viewer', 'Auditor view access without edit or approval permissions.', 10, FALSE, TRUE);

-- 2. SEED PERMISSION LIBRARY (15 Modules)
INSERT INTO public.permissions (module_code, module_name, feature_code, feature_name, action_code, permission_code, description) VALUES
  -- Module 1: Dashboard
  ('dashboard', 'Dashboard', 'provincial_dashboard', 'Provincial Dashboard', 'read', 'dashboard:provincial_dashboard:read', 'View provincial executive analytics'),
  ('dashboard', 'Dashboard', 'district_dashboard', 'District Dashboard', 'read', 'dashboard:district_dashboard:read', 'View district monitoring statistics'),
  
  -- Module 2: User Management
  ('user_management', 'User Management', 'users', 'User Profiles', 'read', 'user_management:users:read', 'View user profile list'),
  ('user_management', 'User Management', 'users', 'User Profiles', 'create', 'user_management:users:create', 'Create new officer accounts'),
  ('user_management', 'User Management', 'users', 'User Profiles', 'update', 'user_management:users:update', 'Update user profiles'),
  ('user_management', 'User Management', 'users', 'User Profiles', 'assign', 'user_management:users:assign', 'Assign roles & access scope'),
  ('user_management', 'User Management', 'roles', 'Roles & RBAC', 'manage_permissions', 'user_management:roles:manage_permissions', 'Manage role permissions'),

  -- Module 3: OMIS Data
  ('omis_data', 'OMIS Data', 'import', 'OMIS Import', 'import', 'omis_data:import:import', 'Import court probation orders'),

  -- Module 4: Supervisee Records
  ('supervisee_records', 'Supervisee Records', 'offender_profiles', 'Offender Profiles', 'read', 'supervisee_records:offender_profiles:read', 'View supervisee profiles'),
  ('supervisee_records', 'Supervisee Records', 'offender_profiles', 'Offender Profiles', 'create', 'supervisee_records:offender_profiles:create', 'Create supervisee record'),
  ('supervisee_records', 'Supervisee Records', 'offender_profiles', 'Offender Profiles', 'update', 'supervisee_records:offender_profiles:update', 'Update supervisee details'),

  -- Module 5: Officer Caseload
  ('officer_caseload', 'Officer Caseload', 'caseload', 'Caseload Mapping', 'read', 'officer_caseload:caseload:read', 'View officer caseload'),

  -- Module 6: Check-Ins
  ('checkins', 'Check-Ins', 'checkin_reports', 'Digital Check-Ins', 'read', 'checkins:checkin_reports:read', 'View check-in reports'),
  ('checkins', 'Check-Ins', 'checkin_reports', 'Digital Check-Ins', 'review', 'checkins:checkin_reports:review', 'Review submitted check-ins'),

  -- Module 7: Verified Attendance
  ('verified_attendance', 'Verified Attendance', 'attendance_reviews', 'Attendance Verification', 'read', 'verified_attendance:attendance_reviews:read', 'View attendance submissions'),
  ('verified_attendance', 'Verified Attendance', 'attendance_reviews', 'Attendance Verification', 'review', 'verified_attendance:attendance_reviews:review', 'Review GPS & photo attendance'),

  -- Module 8: Assigned Activities
  ('assigned_activities', 'Assigned Activities', 'activity_list', 'Activity Assignment', 'create', 'assigned_activities:activity_list:create', 'Assign lawful activities'),

  -- Module 9: PRNA Assessment
  ('prna_assessment', 'PRNA Assessment', 'create_assessment', 'PRNA Tool', 'create', 'prna_assessment:create_assessment:create', 'Conduct PRNA intake assessment'),
  ('prna_assessment', 'PRNA Assessment', 'approve_assessment', 'PRNA Approval', 'approve', 'prna_assessment:approve_assessment:approve', 'Approve PRNA risk band'),

  -- Module 10: Case Planning
  ('case_planning', 'Case Planning', 'create_plan', 'RNR Case Plan', 'create', 'case_planning:create_plan:create', 'Create RNR rehabilitation plan'),
  ('case_planning', 'Case Planning', 'approve_plan', 'Case Plan Approval', 'approve', 'case_planning:approve_plan:approve', 'Approve case plan actions'),

  -- Module 11: Rehabilitation Referrals
  ('rehab_referrals', 'Rehabilitation Referrals', 'referrals', 'Agency Referrals', 'create', 'rehab_referrals:referrals:create', 'Refer to TEVTA or health agency'),

  -- Module 12: Alerts and Compliance
  ('alerts_compliance', 'Alerts & Compliance', 'alerts', 'Compliance Alerts', 'read', 'alerts_compliance:alerts:read', 'View compliance breach alerts'),

  -- Module 13: Reports and Analytics
  ('reports_analytics', 'Reports & Analytics', 'reports', 'Management Reports', 'export', 'reports_analytics:reports:export', 'Export PDF/Excel summary reports'),

  -- Module 14: Audit Trail
  ('audit_trail', 'Audit Trail', 'activity_audit', 'System Audit Trail', 'read', 'audit_trail:activity_audit:read', 'Inspect login and activity audit logs'),

  -- Module 15: System Settings
  ('system_settings', 'System Settings', 'security_settings', 'Security Policy', 'update', 'system_settings:security_settings:update', 'Configure security and timeout rules');

-- 3. SEED ROLE PERMISSIONS (Grant all to Super Admin & System Admin)
INSERT INTO public.role_permissions (role_id, permission_id, allowed)
SELECT r.id, p.id, TRUE
FROM public.roles r
CROSS JOIN public.permissions p
WHERE r.role_code IN ('super_admin', 'system_admin');
