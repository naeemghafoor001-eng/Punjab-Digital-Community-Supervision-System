# User Management & RBAC Setup Guide

**System**: Raahnuma — Punjab Community Supervision System  
**Organization**: Punjab Probation and Parole Service, Home Department, Government of the Punjab  

---

## 1. Supabase SQL Installation Order

To set up the User Management, Authentication & RBAC system in Supabase:

1. Open the Supabase SQL Editor.
2. Execute [user_management_schema.sql](file:///d:/Antigravity/PDCSS/docs/backend/user_management_schema.sql) to create all 10 user management tables (`user_profiles`, `roles`, `permissions`, `role_permissions`, `user_roles`, `user_district_access`, `user_division_access`, `user_office_access`, `login_audit_logs`, `user_activity_audit_logs`).
3. Execute [user_management_rls_policies.sql](file:///d:/Antigravity/PDCSS/docs/backend/user_management_rls_policies.sql) to apply Row Level Security policies.
4. Execute [user_management_seed_roles_permissions.sql](file:///d:/Antigravity/PDCSS/docs/backend/user_management_seed_roles_permissions.sql) to seed default roles, permission library, and initial RBAC mappings.

---

## 2. Supabase Auth Configuration

1. In Supabase Dashboard $\rightarrow$ **Authentication** $\rightarrow$ **Settings**:
   - **Disable Public Self-Registration**: Ensure sign-ups are disabled so that only authorised System Administrators can create accounts.
   - **Email Provider**: Enable Email & Password provider.
   - **Password Policy**: Require minimum 8 characters, numbers, uppercase letters, and special symbols.

---

## 3. Creating Authorised System Administrators

All officer and administrative user accounts must be created by authorised System Administrators:

1. Use the **Raahnuma Secure Access Portal** (Management Web Portal $\rightarrow$ User Management section).
2. Click **Create New Officer Account**.
3. Enter Official Email, Username, Full Name, Masked CNIC, Designation, Officer Type (`Probation Officer`, `Parole Officer`, `Supervisory Officer`, `Administrative Officer`, `System Administrator`), District, Division, and Office Name.
4. Assign System Role (`district_admin`, `probation_officer`, `parole_officer`, etc.) and set District/Division Data Scope.
5. Check **Force Password Change on First Login** for initial account distribution.

---

## 4. Environment Feature Flag (`RESTRICTED_MODE`)

The application supports build-time feature toggling via `--dart-define=RESTRICTED_MODE=true`:

- **Production / Pilot Mode (`RESTRICTED_MODE=true`)**:
  - Forces mandatory login prior to accessing the portal or officer dashboard.
  - Validates user token and active status against `user_profiles`.
  - Filters displayed modules based on active RBAC permissions.
- **Fictional Prototype Mode (`RESTRICTED_MODE=false`)**:
  - Keeps current public demo mode active while offering a header button to launch the **Secure Access Portal** login screen and admin matrix for testing.
