# Punjab Digital Community Supervision System (PDCSS)
## API Design Specification (OpenAPI 3.0 / FastAPI)

### 1. Architectural Standards & Design Patterns
- **Protocol**: RESTful HTTP/2 & HTTP/1.1 over TLS 1.3 (HTTPS).
- **Authentication**: OAuth2 Bearer Token in `Authorization: Bearer <JWT>` header. Token validated against Keycloak Realm.
- **Serialization**: JSON for data payloads; `multipart/form-data` for file/photo uploads.
- **Error Response Standard**: RFC 7807 Problem Details format.
- **Pagination Standard**: Cursor-based or limit-offset (`page=1&limit=20`) with metadata (`total`, `pages`).
- **Rate Limiting Headers**: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`.

---

### 2. Core API Endpoint Catalog

#### 2.1 Authentication & Profile Endpoint Group
- **`GET /api/v1/auth/me`**
  - *Summary*: Fetch authenticated user details, assigned role, office boundaries, and permissions.
  - *Headers*: `Authorization: Bearer <token>`
  - *Response `200 OK`*: User JSON object with masked CNIC and office scope attributes.

- **`POST /api/v1/auth/deregister-device`**
  - *Summary*: Deregister client device and revoke refresh token.
  - *Response `200 OK`*: Confirmation receipt.

---

#### 2.2 Supervisee Registration & Case Management Group
- **`POST /api/v1/supervisees/`**
  - *Summary*: Enroll new supervisee (Officer App only).
  - *Roles Allowed*: `ROLE_PROBATION_OFFICER`, `ROLE_PAROLE_OFFICER`
  - *Request Body (`multipart/form-data`)*: `cnic`, `full_name`, `supervision_type`, `court_order_file`, `base_photo`.
  - *Response `201 Created`*: Created supervisee ID and pairing code.

- **`GET /api/v1/supervisees/`**
  - *Summary*: List supervisees scoped to officer's district/office.
  - *Roles Allowed*: Officers, Supervisors, Monitoring Officers.
  - *Query Params*: `status`, `search_query`, `page`, `limit`.

- **`GET /api/v1/supervisees/{id}`**
  - *Summary*: Get detailed supervisee dossier.
  - *Security*: Row-Level Access Control verification (`id` matched against officer's assigned cases). Returns `403 Forbidden` for unauthorized cases or `ROLE_SYSTEM_ADMIN`.

---

#### 2.3 Digital Check-Ins Endpoint Group
- **`POST /api/v1/checkins/`**
  - *Summary*: Submit a digital check-in with location snapshot and live photo.
  - *Roles Allowed*: `ROLE_SUPERVISEE`, `ROLE_PROBATION_OFFICER` (Officer-Assisted Mode).
  - *Request Body (`multipart/form-data`)*:
    ```json
    {
      "supervisee_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "checkin_type": "SELF_MOBILE",
      "latitude": 31.5204,
      "longitude": 74.3587,
      "accuracy_meters": 8.5,
      "client_timestamp": "2026-07-25T14:30:00Z"
    }
    ```
    + `photo` (file payload)
  - *Response `201 Created`*:
    ```json
    {
      "checkin_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
      "receipt_code": "REC-PDCSS-20260725-88392",
      "receipt_signature": "a8f9b2c3d4e5f6... (HMAC-SHA256)",
      "verification_status": "PENDING_REVIEW",
      "server_timestamp": "2026-07-25T14:30:02Z"
    }
    ```

- **`GET /api/v1/checkins/history`**
  - *Summary*: Fetch check-in history for supervisee or officer review.

---

#### 2.4 Violation & Supervisory Review Group
- **`POST /api/v1/violations/`**
  - *Summary*: Officer records non-compliance incident.
  - *Roles Allowed*: `ROLE_PROBATION_OFFICER`, `ROLE_PAROLE_OFFICER`.

- **`PUT /api/v1/violations/{id}/approve`**
  - *Summary*: District Supervisory Officer approves or rejects violation notice.
  - *Roles Allowed*: `ROLE_DISTRICT_SUPERVISOR`, `ROLE_DIVISIONAL_SUPERVISOR`.

---

#### 2.5 Offline Synchronisation Group
- **`POST /api/v1/sync/batch`**
  - *Summary*: Upload batch of queued offline check-ins, field contact notes, and photos.
  - *Request Body*: Array of pending payload objects with client UUIDs.
  - *Response `200 OK`*: Processing results per payload item (`success`, `duplicate_ignored`, `error`).

---

#### 2.6 Immutable Audit Logs & Reports Group
- **`GET /api/v1/audits/`**
  - *Summary*: Search and query tamper-evident audit records.
  - *Roles Allowed*: `ROLE_AUDIT_OFFICER` (Full), `ROLE_SYSTEM_ADMIN` (System events only).

- **`GET /api/v1/reports/district-summary`**
  - *Summary*: Generate aggregated district compliance statistics.
