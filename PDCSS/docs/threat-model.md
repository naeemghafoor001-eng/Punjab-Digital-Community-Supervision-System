# Punjab Digital Community Supervision System (PDCSS)
## Threat Model and Security Risk Assessment

### 1. Threat Modeling Methodology
The PDCSS threat model applies the **STRIDE** framework (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege) across all system boundaries, including mobile client apps, API endpoints, identity provider (Keycloak), storage (MinIO), and database infrastructure (PostgreSQL).

---

### 2. Threat Vector Analysis & Mitigation Matrix

| Threat ID | STRIDE Category | Threat Description | Attack Vector / Scenario | Impact | Mitigation Strategy |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TM-01** | Spoofing | Impersonation of Supervisee during Digital Check-in | A proxy user attempts check-in using stolen credentials or phone. | High | Live photo capture (no gallery pick), device binding via Keycloak token, location snapshot validation, officer verification. |
| **TM-02** | Tampering | Offline Database Tampering on Mobile Device | Malicious user roots Android device and alters local SQLite check-in records before sync. | Critical | Encrypted SQLite storage via Drift & SQLCipher with keys stored in Android Keystore (`EncryptedSharedPreferences`). Server validates check-in timestamps and HMAC signature. |
| **TM-03** | Repudiation | Supervisee or Officer Denies Performing an Action | User claims a check-in, violation report, or case transfer was logged fraudulently. | High | Immutable audit logging with HMAC-SHA256 hash chaining, recording User ID, IP address, timestamp, device fingerprint, and action payload diff. |
| **TM-04** | Information Disclosure | Unauthorized Access to Probationer Case Files (IDOR) | Officer alters `case_id` in API request URL to view unassigned probationer records. | Critical | Backend Row-Level Access Control (RLAC) middleware verifying officer-case assignment in PostgreSQL on every request. Direct Object Reference mapping via random UUID v4. |
| **TM-05** | Information Disclosure | Exposure of PII (CNIC, Mobile) in UI or API Logs | CNIC or mobile number printed in application logs or shown on public dashboard screens. | High | PII masking (`35202-******-1`) in API serializers and frontend components. Structured logging filter stripping CNIC/phone/passwords before writing to log files. |
| **TM-06** | Denial of Service | API Flooding or Automated Check-in Spam | Botnet or malicious script spams `/api/v1/checkins/` endpoint. | Medium | Nginx rate limiting (10 req/sec per IP) + FastAPI `slowapi` rate limiting per user token. Cloudflare/WAF DDoS protection. |
| **TM-07** | Elevation of Privilege | System Administrator Accessing Operational Case Notes | IT Administrator uses DB or admin portal credentials to read probationer psychological reports. | High | Strict role isolation in API layer. System Admin role (`ROLE_SYSTEM_ADMIN`) explicitly blocked from case content endpoints. Separate database schema roles for admin vs app connection. |
| **TM-08** | Tampering | File Upload Malware Injection | Malicious user uploads executable payload disguised as PDF court order or JPEG photo. | Critical | MIME-type validation, magic byte header verification, file size limits (5MB photo, 10MB doc), safe randomized filename storage in MinIO, non-executable bucket execution policies. |
| **TM-09** | Information Disclosure | Man-in-the-Middle (MitM) Interception of Mobile Traffic | Adversary intercepts HTTP traffic on public Wi-Fi network. | Critical | Mandatory TLS 1.3 encryption (HTTPS/WSS) with SSL certificate pinning in Flutter mobile apps. |

---

### 3. Vulnerability Prevention Checklist
- **SQL Injection**: Prevented via SQLAlchemy ORM parameterized queries; raw SQL queries are explicitly forbidden.
- **Cross-Site Scripting (XSS)**: Prevented via Flutter auto-escaping widgets, Web Portal React/Angular auto-sanitization, and HTTP Content Security Policy (CSP) headers.
- **Cross-Site Request Forgery (CSRF)**: Prevented via SameSite=Strict cookies, OAuth2 Bearer Tokens, and state validation headers.
- **Password Security**: Managed by Keycloak IAM; local password fallback requires Argon2id (`time_cost=3`, `memory_cost=65536`).
