# Raahnuma — Real Data Testing & Compliance Checklist

This checklist defines the safety regulations, environment restrictions, and audit protocols required by the **Home Department, Government of the Punjab** before migrating from fictional demonstration data to restricted pilot testing with real records.

---

## 1. Environment & Git Isolation

- [ ] **Strict Environment Separation**:
  - Maintain a separate local/staging environment (`raahnuma-pilot`) with RLS enabled.
  - The public production branch or any public GitHub Pages deployment must **never** be pointed to real data.
- [ ] **Credentials Protection**:
  - Verify that `.env` files containing actual Supabase URLs, Anon Keys, and Service Role Keys are listed in `.gitignore` and never committed to version control.
- [ ] **No Local Dumps in Codebase**:
  - Database backup dumps containing real probationer records must not be stored inside repository folders.

---

## 2. PII & Identity Compliance

- [ ] **CNIC Masking**:
  - Full CNIC numbers must **not** be stored in the database.
  - The database field `cnic_masked` must strictly enforce the `check_cnic_masked` regex constraint (`^\d{5}-[xX]{7}-\d$`), allowing only masked CNIC entries (e.g., `35201-xxxxxxx-9`).
- [ ] **Data Minimization**:
  - Do not record home addresses or phone numbers of supervisees inside the database unless encrypted.

---

## 3. Row Level Security & Access Control

- [ ] **Verify active RLS Policies**:
  - Run database queries to verify that `ROW LEVEL SECURITY` is enabled on all 10 tables.
  - Verify that **no DELETE policies** exist on any table.
- [ ] **Disable Anonymous Access**:
  - Ensure that no database table has a policy permitting read/write operations to the `anon` (anonymous public) role in production.
  - All access must be filtered through `auth.uid()` under the `authenticated` role.

---

## 4. Hardware, Attendance & Decision Restrictions

- [ ] **Single-Point GPS Capture**:
  - Location must be captured ONLY once at the time of attendance submission after explicit user permission.
  - No continuous background GPS tracking is permitted.
  - Display clear notice: "Location captured for attendance verification only."
- [ ] **Camera & Photo Privacy**:
  - Camera permissions requested only when required for attendance photo.
  - Photos stored only in private storage bucket `attendance-photos` with authenticated signed URL access.
- [ ] **Biometric Safety Compliance**:
  - Do NOT generate or store biometric templates.
  - Do NOT perform facial recognition or face matching against any database.
  - Liveness prompts (blink, head movement) serve only as interaction steps for officer visual review.
- [ ] **No Automated Supervision Decisions**:
  - Location/photo/liveness indicators serve solely as decision support aids for officer review.
  - The system must not create automated legal violation findings or disciplinary sanctions without formal officer review and hearing.

---

## 5. Audit Log Integrity

- [ ] **Immutable Logs**:
  - Ensure that the `activities` table RLS policies explicitly disable the `UPDATE` operation.
- [ ] **Integrity Hash Validation**:
  - Execute audit reviews of system actions by verifying the SHA-256 chain integrity hashes on the `activities` table.

