# User Management & RBAC Security Policy

**Department**: Punjab Probation and Parole Service  
**Parent Entity**: Home Department, Government of the Punjab  
**System**: Raahnuma — Punjab Community Supervision System  

---

## 1. Authentication & Access Control Principles

1. **Restricted Access**: Access is strictly limited to authorised PP&PS officers and administrative personnel. Public self-registration is strictly disabled.
2. **Credential Safety**:
   - Client applications **must never** expose `service_role` keys, database passwords, or hard-coded user credentials.
   - Passwords must be managed via Supabase Auth and hashed according to standard cryptographic recommendations.
3. **Role-Based Access Control (RBAC)**: All administrative, supervision, assessment, and reporting capabilities are enforced via role-permission mappings.
4. **Data Scope Isolation**:
   - **Probation & Parole Officers**: Access assigned offender caseloads only.
   - **District Administrators**: Access records within assigned district boundaries.
   - **Divisional Administrators**: Access records across assigned division.
   - **Directorate General**: Access provincial-level executive metrics and audit reports.

---

## 2. Password & Account Lifecycle Policy

- **Minimum Complexity**: 8+ characters including uppercase, lowercase, numeric, and special characters.
- **Initial Login**: New user profiles require mandatory password change (`must_change_password = true`).
- **Account Deactivation**: When an officer is transferred or departs, the account must be set to `is_active = false`. Accounts are **never hard-deleted** to protect legal audit logs.
- **Failed Login Lockout**: 5 consecutive failed login attempts lock the account for 15 minutes and trigger an automated security audit entry in `login_audit_logs`.

---

## 3. Two-Factor Authentication Roadmap

> [!NOTE]
> **2FA Roadmap Statement**: “Two-factor authentication (SMS OTP or TOTP Authenticator App) may be enabled in restricted production deployment following Home Department cybersecurity clearance.”

---

## 4. Audit Trail Retention Policy

- **Login Audit Logs**: Retained for a minimum of 24 months.
- **Activity Audit Logs**: Retained permanently. NORMAL users cannot modify or delete audit log rows. Audit log tables enforce append-only policies (`INSERT` for users, `SELECT` for authorised administrators).
