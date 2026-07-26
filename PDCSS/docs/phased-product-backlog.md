# Punjab Digital Community Supervision System (PDCSS)
## Phased Product Backlog and Task Specification

---

### Phase 1: Foundation, Infrastructure & Identity (Sprint 1 - 2)

#### Task 1.1: Docker Environment & Container Infrastructure
- **1. Objective**: Set up containerized local development environment containing Nginx, FastAPI, PostgreSQL+PostGIS, Keycloak, MinIO, and Redis via Docker Compose.
- **2. Files Expected to Change**:
  - `docker-compose.yml` [NEW]
  - `docker/nginx/nginx.conf` [NEW]
  - `docker/postgres/init-postgis.sql` [NEW]
  - `.env.example` [NEW]
- **3. Acceptance Criteria**: Running `docker compose up -d` boots all services with clean healthchecks. PostgreSQL initializes PostGIS extension. Keycloak realm imports default roles.
- **4. Tests Required**: Integration script verifying inter-container network connectivity and health endpoints.
- **5. Security Considerations**: No default passwords in production templates; all credentials read from `.env`. Nginx configures TLS 1.3 headers.
- **6. Privacy Considerations**: Storage volumes isolated; public port bindings restricted to proxy edge.
- **7. Dependencies**: None.

#### Task 1.2: FastAPI Project Architecture & Keycloak JWT Authentication Middleware
- **1. Objective**: Initialize Python FastAPI backend skeleton with Pydantic settings, SQLAlchemy ORM, and Keycloak JWT authentication middleware.
- **2. Files Expected to Change**:
  - `backend/app/main.py` [NEW]
  - `backend/app/core/config.py` [NEW]
  - `backend/app/core/security.py` [NEW]
  - `backend/app/api/deps.py` [NEW]
  - `backend/requirements.txt` [NEW]
- **3. Acceptance Criteria**: Requesting protected endpoints without valid Bearer token returns HTTP 401. Valid JWT returns user context with role claims.
- **4. Tests Required**: `pytest` tests validating valid token, expired token, tampered token, and missing authorization header.
- **5. Security Considerations**: Validate JWT signature against Keycloak JWKS endpoint; reject weak or unsigned algorithms (`alg: none`).
- **6. Privacy Considerations**: Do not log raw JWT strings or authorization headers in server logs.
- **7. Dependencies**: Task 1.1.

#### Task 1.3: Cryptographic Audit Logging Middleware
- **1. Objective**: Implement FastAPI audit logging middleware that records all API write operations into an immutable audit table using HMAC-SHA256 hash chaining.
- **2. Files Expected to Change**:
  - `backend/app/models/audit.py` [NEW]
  - `backend/app/middleware/audit_middleware.py` [NEW]
  - `backend/app/services/audit_service.py` [NEW]
- **3. Acceptance Criteria**: Every POST/PUT/DELETE request generates an `audit_logs` record containing `user_id`, `action`, `changes_diff`, and valid `current_record_hash` chained to `previous_record_hash`.
- **4. Tests Required**: Unit tests verifying hash chain creation and chain integrity verification failure detection.
- **5. Security Considerations**: Audit secret key loaded from secure environment variable. Append-only database table permissions.
- **6. Privacy Considerations**: PII fields (CNIC, phone, passwords) stripped from `changes_diff` payload before hashing.
- **7. Dependencies**: Task 1.2.

---

### Phase 2: User Hierarchy, Supervisee Enrolment & Master Profiles (Sprint 3 - 4)

#### Task 2.1: Office Hierarchy & User Profile Database Schemas
- **1. Objective**: Implement PostgreSQL database models and Alembic migrations for `offices`, `users`, and `supervisees` tables with spatial PostGIS geometries.
- **2. Files Expected to Change**:
  - `backend/app/db/base.py` [NEW]
  - `backend/app/models/office.py` [NEW]
  - `backend/app/models/user.py` [NEW]
  - `backend/app/models/supervisee.py` [NEW]
  - `backend/alembic/versions/001_initial_schema.py` [NEW]
- **3. Acceptance Criteria**: Database migration completes cleanly. Spatial index created on `location` columns. Foreign key constraints enforced.
- **4. Tests Required**: Alembic upgrade/downgrade test; SQLAlchemy ORM CRUD unit tests.
- **5. Security Considerations**: CNIC and mobile numbers encrypted at rest using AES-256 in DB columns alongside masked string columns.
- **6. Privacy Considerations**: Default serializers return masked CNIC (`35202-******-1`).
- **7. Dependencies**: Task 1.2.

#### Task 2.2: Supervisee Registration API Endpoints & Row-Level Authorization
- **1. Objective**: Create FastAPI endpoints for officer-led supervisee enrolment, profile retrieval, and case listing with strict Row-Level Access Control (RLAC).
- **2. Files Expected to Change**:
  - `backend/app/api/v1/endpoints/supervisees.py` [NEW]
  - `backend/app/schemas/supervisee.py` [NEW]
  - `backend/app/crud/crud_supervisee.py` [NEW]
- **3. Acceptance Criteria**: Probation Officer can register supervisee and view assigned cases. Accessing unassigned probationer returns 403 Forbidden. System Admin access returns 403 Forbidden.
- **4. Tests Required**: Automated permission matrix tests verifying all 10 user roles against supervisee endpoints.
- **5. Security Considerations**: Prevent IDOR vulnerabilities by validating officer assignment in DB query filter.
- **6. Privacy Considerations**: Enforce consent modal requirement flag in enrolment response.
- **7. Dependencies**: Task 2.1.

#### Task 2.3: MinIO Document & Base Photograph Storage Integration
- **1. Objective**: Implement secure file upload service connecting FastAPI to MinIO S3 object storage for court orders and supervisee base photos.
- **2. Files Expected to Change**:
  - `backend/app/services/storage_service.py` [NEW]
  - `backend/app/api/v1/endpoints/documents.py` [NEW]
- **3. Acceptance Criteria**: Uploaded files stored with randomized UUID object keys. MIME types verified via magic byte inspection. Executable files rejected.
- **4. Tests Required**: Unit tests for MIME validation, file size enforcement (5MB photo, 10MB doc), and invalid file extension rejection.
- **5. Security Considerations**: Sanitize file names; disable public bucket listing; enforce short-lived presigned download URLs.
- **6. Privacy Considerations**: MinIO bucket encrypted at rest; access logged in audit table.
- **7. Dependencies**: Task 1.1, Task 2.2.

---

### Phase 3: Digital Check-Ins, Mobile Offline Sync & Map Integration (Sprint 5 - 6)

#### Task 3.1: Supervisee Android App Foundation & Drift Encrypted SQLite Storage
- **1. Objective**: Initialize Flutter Supervisee Android application with BLoC state management, Drift SQLite database, and SQLCipher encryption.
- **2. Files Expected to Change**:
  - `apps/supervisee_app/pubspec.yaml` [NEW]
  - `apps/supervisee_app/lib/main.dart` [NEW]
  - `apps/supervisee_app/lib/core/database/app_database.dart` [NEW]
  - `apps/supervisee_app/lib/core/security/key_storage.dart` [NEW]
- **3. Acceptance Criteria**: App compiles on Android 8.0+. SQLite database encrypted via SQLCipher key stored in Android Keystore.
- **4. Tests Required**: Flutter unit tests for local database CRUD operations and encryption key generation.
- **5. Security Considerations**: Clear in-memory encryption keys on app exit; disable Android backup flags in `AndroidManifest.xml`.
- **6. Privacy Considerations**: Local database stores zero unencrypted PII.
- **7. Dependencies**: None.

#### Task 3.2: Foreground Location Snapshot & Camera Capture Module
- **1. Objective**: Implement Flutter camera and location collection widgets with mandatory bilingual privacy consent modal.
- **2. Files Expected to Change**:
  - `apps/supervisee_app/lib/features/checkin/widgets/consent_dialog.dart` [NEW]
  - `apps/supervisee_app/lib/features/checkin/services/location_service.dart` [NEW]
  - `apps/supervisee_app/lib/features/checkin/services/camera_service.dart` [NEW]
- **3. Acceptance Criteria**: Consent dialog shown before permission request. Camera captures live photo (no gallery picker). Location fetched exclusively during active button press.
- **4. Tests Required**: Widget tests for consent dialog rendering; mock unit tests for location service bounds.
- **5. Security Considerations**: Prevent image pick from file system/gallery; attach timestamp and checksum to photo payload.
- **6. Privacy Considerations**: Strictly no background location services or persistent GPS listeners.
- **7. Dependencies**: Task 3.1.

#### Task 3.3: Digital Check-In API & Batch Sync Engine
- **1. Objective**: Create FastAPI `/api/v1/checkins` and `/api/v1/sync/batch` endpoints for check-in processing, PostGIS point storage, and digital receipt signature generation.
- **2. Files Expected to Change**:
  - `backend/app/api/v1/endpoints/checkins.py` [NEW]
  - `backend/app/api/v1/endpoints/sync.py` [NEW]
  - `backend/app/models/checkin.py` [NEW]
  - `backend/app/services/receipt_service.py` [NEW]
- **3. Acceptance Criteria**: Endpoint processes batch payload, validates client UUID idempotency, saves spatial point, generates signed receipt code (`REC-PDCSS-...`), and writes audit entry.
- **4. Tests Required**: Integration tests for batch sync processing, de-duplication, and HMAC receipt signature verification.
- **5. Security Considerations**: Rate limit check-in submissions; validate client timestamp skew.
- **6. Privacy Considerations**: Spatial coordinates linked strictly to explicit check-in ID.
- **7. Dependencies**: Task 2.2, Task 3.2.

---

### Phase 4: Risk & Needs Assessment (RNA), ISRP & Violation Workflows (Sprint 7 - 8)

#### Task 4.1: RNA & Individual Supervision Plan Backend Modules
- **1. Objective**: Develop database models and REST endpoints for Risk & Needs Assessment scoring and Individual Supervision & Rehabilitation Plans (ISRP).
- **2. Files Expected to Change**:
  - `backend/app/models/rna.py` [NEW]
  - `backend/app/models/isrp.py` [NEW]
  - `backend/app/api/v1/endpoints/assessments.py` [NEW]
- **3. Acceptance Criteria**: Probation Officer can record RNA responses, total risk score, risk tier (Low/Medium/High), and create ISRP goals with referral tracking.
- **4. Tests Required**: Unit tests for risk tier scoring logic; integration tests for assessment API CRUD operations.
- **5. Security Considerations**: Restrict modification of completed assessments to original officer or supervisor.
- **6. Privacy Considerations**: Psychological/substance abuse assessment data flagged as highly restricted.
- **7. Dependencies**: Task 2.2.

#### Task 4.2: Human-in-the-Loop Violation Recording & Supervisory Approval Workflow
- **1. Objective**: Implement violation recording API and multi-step supervisory approval workflow.
- **2. Files Expected to Change**:
  - `backend/app/models/violation.py` [NEW]
  - `backend/app/api/v1/endpoints/violations.py` [NEW]
  - `backend/app/services/notification_service.py` [NEW]
- **3. Acceptance Criteria**: Officer logs non-compliance incident. Status set to `PENDING_APPROVAL`. District Supervisor reviews dossier and approves/rejects notice. **No automated sanctions.**
- **4. Tests Required**: Workflow integration test verifying state transitions and permission enforcement.
- **5. Security Considerations**: Require supervisor credential re-validation before finalizing violation approval.
- **6. Privacy Considerations**: Log all supervisory comment edits in tamper-evident audit table.
- **7. Dependencies**: Task 4.1.

---

### Phase 5: Web Management Portal, Dashboards & Audit Tools (Sprint 9 - 10)

#### Task 5.1: Admin & Management Web Portal Foundation (Flutter Web)
- **1. Objective**: Build responsive Flutter Web Portal interface integrated with Keycloak JS login and OpenStreetMap component (`flutter_map`).
- **2. Files Expected to Change**:
  - `apps/web_portal/pubspec.yaml` [NEW]
  - `apps/web_portal/lib/main.dart` [NEW]
  - `apps/web_portal/lib/features/dashboard/screens/district_dashboard_screen.dart` [NEW]
  - `apps/web_portal/lib/features/map/widgets/osm_map_widget.dart` [NEW]
- **3. Acceptance Criteria**: Web portal authenticates via Keycloak; renders District compliance dashboard and OpenStreetMap layer displaying office locations and anonymized check-in clusters.
- **4. Tests Required**: Flutter web widget tests; cross-browser layout rendering tests (Chrome, Firefox, Edge).
- **5. Security Considerations**: Secure HTTP-only session cookie management; CSP header enforcement.
- **6. Privacy Considerations**: Map component displays aggregated cluster markers; exact probationer home addresses are hidden unless authorized.
- **7. Dependencies**: Task 1.2, Task 3.3.

#### Task 5.2: Audit Officer Verification Interface & Log Viewer
- **1. Objective**: Create dedicated Audit Officer interface in Web Portal for querying tamper-evident audit logs and running hash chain integrity checks.
- **2. Files Expected to Change**:
  - `apps/web_portal/lib/features/audit/screens/audit_log_screen.dart` [NEW]
  - `backend/app/api/v1/endpoints/audits.py` [NEW]
- **3. Acceptance Criteria**: Audit Officer can filter logs by date, user ID, role, and action type, and trigger on-demand hash chain integrity verification.
- **4. Tests Required**: Unit tests for audit log query filters and integrity check API response validation.
- **5. Security Considerations**: Endpoint strictly restricted to `ROLE_AUDIT_OFFICER`; read-only database connections used.
- **6. Privacy Considerations**: View actions logged in meta-audit log.
- **7. Dependencies**: Task 1.3, Task 5.1.

---

### Phase 6: Localisation, Accessibility & Hardening (Sprint 11 - 12)

#### Task 6.1: English & Urdu Full App Localisation (RTL Support)
- **1. Objective**: Implement complete English and Urdu localization strings (`arb` files), right-to-left (RTL) layout switching, and Noto Nastaliq Urdu font integration.
- **2. Files Expected to Change**:
  - `apps/supervisee_app/lib/l10n/app_en.arb` [NEW]
  - `apps/supervisee_app/lib/l10n/app_ur.arb` [NEW]
  - `apps/officer_app/lib/l10n/app_ur.arb` [NEW]
  - `apps/web_portal/lib/l10n/app_ur.arb` [NEW]
- **3. Acceptance Criteria**: Users can toggle between English and Urdu. UI automatically mirrors layout direction for RTL. All buttons, titles, messages, and receipts render cleanly in Urdu.
- **4. Tests Required**: Golden widget tests for Urdu RTL layout rendering; translation string coverage check.
- **5. Security Considerations**: Validate localized text inputs against script injection.
- **6. Privacy Considerations**: Clear plain-language Urdu text used for all privacy consent dialogs.
- **7. Dependencies**: All UI tasks (3.1, 5.1).

#### Task 6.2: Accessibility & Low-Spec Android Device Optimization
- **1. Objective**: Optimize Android apps for screen reader compatibility (TalkBack / Semantics), large touch targets (48x48dp), and low-spec Android 8.0 hardware.
- **2. Files Expected to Change**:
  - `apps/supervisee_app/lib/core/theme/app_theme.dart` [NEW]
  - `apps/officer_app/lib/core/theme/app_theme.dart` [NEW]
- **3. Acceptance Criteria**: App passes Google Accessibility Scanner with 0 errors. All interactive components meet min 48x48dp touch target. Flutter APK bundle size < 25 MB.
- **4. Tests Required**: Automated Flutter accessibility guideline tests (`meetsGuideline(androidTapTargetGuideline)`).
- **5. Security Considerations**: Ensure screen privacy flag set (`FLAG_SECURE`) to prevent unauthorized screenshots of sensitive app screens.
- **6. Privacy Considerations**: Support large text scaling for low-vision supervisees.
- **7. Dependencies**: Task 6.1.
