# Punjab Digital Community Supervision System (PDCSS)
## Non-Functional Requirements Specification

### 1. Security Requirements
- **NFR-SEC-01**: **Backend Permission Validation**: Backend API must validate user credentials, role claims, and office assignment scopes on *every* HTTP request using FastAPI middleware.
- **NFR-SEC-02**: **Least Privilege RBAC**: Users must strictly access only data and functions required for their specific role and assigned jurisdiction.
- **NFR-SEC-03**: **IDOR Prevention**: All API endpoints accepting resource IDs must verify that the requesting user has explicit database authorization to access that specific UUID.
- **NFR-SEC-04**: **Token Management**: Access tokens (JWT) shall be short-lived (15 minutes). Refresh tokens shall be stored in secure device storage (Flutter Secure Storage / EncryptedSharedPreferences on Android; HTTP-only secure cookies on Web).
- **NFR-SEC-05**: **File Security**: All uploaded files (photos, documents) must be validated for MIME type, magic bytes, maximum size (5 MB for photos, 10 MB for documents), and sanitized filenames.
- **NFR-SEC-06**: **Data Hashing & Secrets**: System secrets and API keys must never be hardcoded. Fallback local password hashing must use Argon2id (`time_cost=3`, `memory_cost=65536`, `parallelism=4`).

### 2. Privacy Requirements
- **NFR-PRV-01**: **No Continuous Tracking**: Background location streaming, continuous GPS logging, and geofencing are strictly prohibited. Location coordinates are collected solely during active check-in or field contact submissions.
- **NFR-PRV-02**: **Camera & Location Consent**: Interfaces must present an explicit explanation dialog in English and Urdu detailing why camera or location access is required *before* triggering system permission prompts.
- **NFR-PRV-03**: **Data Masking**: National Identity Card numbers (CNIC) and personal mobile numbers must be masked in UI lists (e.g., `35202-******-1` and `0300-******7`) unless full display is authorized for an officer managing that case.
- **NFR-PRV-04**: **Officer-Assisted Fallback**: Smartphone ownership must not be mandatory. The system must support officer-assisted registration and check-in workflows for supervisees without smartphones.

### 3. Performance & Scalability Requirements
- **NFR-PRF-01**: **API Response Time**: 95% of standard read/write API requests must respond within 300 ms under normal load.
- **NFR-PRF-02**: **System Capacity**: System must support 40,000 active supervisees, 1,000 concurrent officer connections, and 100,000 daily digital check-ins across Punjab.
- **NFR-PRF-03**: **Database Optimization**: PostgreSQL database must utilize spatial PostGIS indexes (`GIST` on `GEOMETRY(Point, 4326)`), index foreign keys, and optimize JSON query execution.

### 4. Reliability & Availability Requirements
- **NFR-REL-01**: **System Uptime**: Core backend server infrastructure must achieve 99.5% uptime during operational hours (06:00 to 22:00 PKT).
- **NFR-REL-02**: **Offline Mobile Resilience**: Mobile applications must function reliably without network connectivity, queuing local check-ins and field notes in encrypted Drift/SQLite storage.
- **NFR-REL-03**: **Data Backup & Restoration**: Database backups (full daily, WAL archive continuous) must be encrypted and stored in secondary data center locations with verified automated restoration scripts.

### 5. Accessibility & Usability Requirements
- **NFR-ACC-01**: **Bilingual Localization**: Full UI support for English and Urdu with seamless Right-to-Left (RTL) layout switching in Flutter apps and Web Portal.
- **NFR-ACC-02**: **Touch Target Standards**: Touch elements in mobile apps must meet minimum dimensions of 48 x 48 dp for easy tapping on low-cost devices.
- **NFR-ACC-03**: **Screen Reader Support**: All visual UI elements must provide clear Semantics labels in Flutter and ARIA attributes in Web for TalkBack and screen reader users.
- **NFR-ACC-04**: **Multi-Modal Status Indicators**: Status indicators (Compliant, Pending, Overdue, Violation) must combine text labels, distinct icons, and shape patterns rather than relying on color alone.
- **NFR-ACC-05**: **Low-Spec Android Device Support**: Android apps must be optimized for devices with 2 GB RAM running Android 8.0 (API level 26) with minimal app bundle size (< 25 MB).
