# Punjab Digital Community Supervision System (PDCSS)
## System Architecture Specification

### 1. Architectural Overview & Component Architecture

PDCSS follows a containerized, decoupled microservices-friendly architecture comprising client applications, API reverse proxy layer, core application services, identity management, storage engines, and immutable audit logs.

```mermaid
graph TB
    subgraph Client Layer
        A[Supervisee Android App\nFlutter / Drift SQLite]
        B[Officer Android App\nFlutter / Drift SQLite]
        C[Admin & Management Web Portal\nFlutter Web / Keycloak JS]
    end

    subgraph Edge Layer
        D[Nginx Reverse Proxy\nTLS 1.3 / Rate Limiting / WAF]
    end

    subgraph Identity & Access
        E[Keycloak IAM\nOAuth2 / OIDC / RBAC]
    end

    subgraph Application API Layer
        F[Python FastAPI Backend\nAsync REST Services]
        G[Celery / Redis\nBackground Task Queue]
    end

    subgraph Storage Layer
        H[(PostgreSQL + PostGIS\nMain Spatial DB)]
        I[(MinIO S3\nEncrypted Media Storage)]
        J[(Redis Cache\nSession / Rate Limits)]
        K[(Audit Log Database\nHMAC Chained Logs)]
    end

    A -->|HTTPS / WSS| D
    B -->|HTTPS / WSS| D
    C -->|HTTPS| D

    D -->|Auth Checks| E
    D -->|API Traffic| F

    F -->|JWT Validation| E
    F -->|ORM Queries| H
    F -->|S3 Upload / Download| I
    F -->|Caching & Rate Limits| J
    F -->|Append Audit Records| K
    F -->|Enqueue Push / SMS| G
```

---

### 2. Core Workflow Mermaid Diagrams

#### Diagram 1: User Authentication Sequence
```mermaid
sequenceDiagram
    autonumber
    participant App as Client Application (Flutter)
    participant SecureStorage as Secure Storage (Keystore/Keychain)
    participant Nginx as Nginx Proxy
    participant Keycloak as Keycloak IAM
    participant API as FastAPI Backend Server
    participant DB as PostgreSQL DB

    App->>Keycloak: 1. Request Auth Token (Username/Password or Refresh Token)
    Keycloak-->>App: 2. Return Signed JWT (Access Token 15m + Refresh Token)
    App->>SecureStorage: 3. Encrypt & Store Refresh Token
    App->>Nginx: 4. API Request with Authorization Bearer JWT
    Nginx->>API: 5. Forward Validated SSL Request
    API->>Keycloak: 6. Validate Token Public Key & Scopes
    API->>DB: 7. Validate User Office Scope (ABAC check)
    DB-->>API: 8. Scope OK
    API-->>App: 9. Return Protected Data Payload
```

---

#### Diagram 2: Supervisee Enrolment Workflow
```mermaid
sequenceDiagram
    autonumber
    participant Officer as Probation Officer (Officer App)
    participant API as FastAPI Backend
    participant MinIO as MinIO Storage
    participant DB as PostgreSQL DB
    participant Keycloak as Keycloak IAM

    Officer->>Officer: 1. Enter CNIC, Legal Order, Phone, Profile Data
    Officer->>Officer: 2. Capture Live Base Photograph
    Officer->>API: 3. Submit Enrolment Payload & Photo Base64/Multipart
    API->>MinIO: 4. Sanitize & Store Base Photo (S3 Bucket)
    MinIO-->>API: 5. Return Photo S3 Object Key
    API->>DB: 6. Save Supervisee Profile & Case Record
    API->>Keycloak: 7. Provision Supervisee Keycloak Account
    Keycloak-->>API: 8. Return Supervisee User ID
    API-->>Officer: 9. Return Enrolment Confirmation & QR / Pairing Code
```

---

#### Diagram 3: Digital Check-In Sequence
```mermaid
sequenceDiagram
    autonumber
    participant Supervisee as Supervisee App
    participant GPS as Device GPS (Foreground Only)
    participant Camera as Device Camera (Live)
    participant API as FastAPI Backend
    participant MinIO as MinIO Storage
    participant DB as PostgreSQL DB
    participant Audit as Audit Logger

    Supervisee->>Supervisee: 1. Display Camera & Location Consent Modal
    Supervisee->>GPS: 2. Request Foreground Location (Latitude, Longitude)
    GPS-->>Supervisee: 3. Return Location Point
    Supervisee->>Camera: 4. Capture Live Check-in Photograph
    Camera-->>Supervisee: 5. Return Photo Stream
    Supervisee->>API: 6. POST /api/v1/checkins (Payload + Photo + Location)
    API->>MinIO: 7. Save Photo to MinIO Bucket
    API->>DB: 8. Insert Checkin Record with PostGIS Point
    API->>Audit: 9. Write HMAC Audit Log Record
    API-->>Supervisee: 10. Return Signed Receipt (Receipt Code, SHA-256 Hash)
    Supervisee->>Supervisee: 11. Render Local Submission Receipt Screen
```

---

#### Diagram 4: Appointment Workflow
```mermaid
sequenceDiagram
    autonumber
    participant Officer as Officer / Rehab Specialist
    participant API as FastAPI Backend
    participant Celery as Task Queue (Celery/Redis)
    participant SMS as PITB / Telecom SMS Gateway
    participant Supervisee as Supervisee App

    Officer->>API: 1. POST /api/v1/appointments (Schedule Visit / Session)
    API->>API: 2. Validate Schedule Conflicts
    API-->>Officer: 3. Return Appointment Confirmed
    API->>Celery: 4. Enqueue Reminder Tasks (24h & 2h prior)
    Celery->>SMS: 5. Trigger SMS Reminder to Supervisee Mobile
    Celery->>Supervisee: 6. Send Push Notification (FCM)
    Supervisee->>API: 7. GET /api/v1/appointments (View Details)
```

---

#### Diagram 5: Violation Review Workflow (Human-in-the-Loop)
```mermaid
sequenceDiagram
    autonumber
    participant Officer as Probation Officer
    participant API as FastAPI Backend
    participant Supervisor as District Supervisory Officer
    participant Audit as Audit Log

    Officer->>API: 1. POST /api/v1/violations (Record Non-Compliance & Evidence)
    API->>API: 2. Flag Case Status as "Violation Under Review"
    API->>Supervisor: 3. Send High-Priority Notification to Supervisor
    Supervisor->>API: 4. Review Violation Dossier & Supervisee Statement
    alt Approve Violation Notice
        Supervisor->>API: 5a. Action: APPROVE (Formally Record Non-Compliance)
        API->>Audit: 6a. Log Approved Violation Event
    else Reject / Grant Extension
        Supervisor->>API: 5b. Action: REJECT / EXTEND (Request Officer Follow-up)
        API->>Audit: 6b. Log Rejection / Extension Event
    end
    API-->>Officer: 7. Notify Officer of Decision
```

---

#### Diagram 6: Offline Synchronisation Mechanism
```mermaid
sequenceDiagram
    autonumber
    participant App as Mobile App (Flutter)
    participant Drift as Local Encrypted Drift SQLite
    participant SyncMgr as Flutter Sync Manager
    participant API as FastAPI Backend

    Note over App, Drift: Device Offline (No Cellular Signal)
    App->>Drift: 1. Store Pending Check-in / Field Contact Note in Local Queue
    Drift-->>App: 2. Confirm Local Save & Issue Offline Receipt
    Note over App, SyncMgr: Network Connection Restored
    SyncMgr->>Drift: 3. Fetch Unsynced Queue Items
    SyncMgr->>API: 4. POST /api/v1/sync/batch (Send Enqueued Records)
    API->>API: 5. Process Batch, De-duplicate using UUIDs & Client Timestamps
    API-->>SyncMgr: 6. Return Batch Processing Receipts & Status
    SyncMgr->>Drift: 7. Mark Records as Synced / Clear Local Queue
```

---

#### Diagram 7: Case Transfer Workflow
```mermaid
sequenceDiagram
    autonumber
    participant Initiator as Origin Officer (District A)
    participant API as FastAPI Backend
    participant OrigSup as District Supervisor (District A)
    participant RecSup as District Supervisor (District B)
    participant RecOfficer as Receiving Officer (District B)

    Initiator->>API: 1. Initiate Transfer Request (Target District B, Reason)
    API->>OrigSup: 2. Notify Origin Supervisor
    OrigSup->>API: 3. Endorse Transfer Request
    API->>RecSup: 4. Notify Receiving District Supervisor
    RecSup->>API: 5. Approve Transfer & Assign to RecOfficer
    API->>API: 6. Update Case Primary Officer & Office Scope in DB
    API->>RecOfficer: 7. Notify Receiving Officer of New Case Assignment
```
