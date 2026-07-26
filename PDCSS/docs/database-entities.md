# Punjab Digital Community Supervision System (PDCSS)
## Database Entities and Relational Schema Design

### 1. Database Tech Stack & Design Rules
- **Database Engine**: PostgreSQL 15+ with PostGIS 3+ extensions enabled.
- **Primary Key Standard**: `UUID v4` generated server-side for all entities to prevent enumeration attacks and simplify offline syncing.
- **Audit Columns**: Every table includes `created_at`, `created_by`, `updated_at`, `updated_by`, and soft-delete flag `is_deleted`.
- **Spatial Coordinates**: Location points stored using PostGIS `GEOMETRY(Point, 4326)` (WGS 84 coordinate system) with `GIST` spatial indexing.

---

### 2. Core Entity Relationship Specifications

#### 2.1 Offices & Jurisdiction Hierarchy
```sql
CREATE TABLE offices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    office_name VARCHAR(150) NOT NULL,
    office_code VARCHAR(50) UNIQUE NOT NULL,
    office_type VARCHAR(30) NOT NULL CHECK (office_type IN ('DIRECTORATE', 'DIVISION', 'DISTRICT', 'TEHSIL')),
    parent_office_id UUID REFERENCES offices(id),
    district_code VARCHAR(50),
    division_code VARCHAR(50),
    address TEXT,
    location GEOMETRY(Point, 4326),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_offices_parent ON offices(parent_office_id);
CREATE INDEX idx_offices_spatial ON offices USING GIST(location);
```

#### 2.2 User Profiles (Linked to Keycloak Identity)
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    keycloak_user_id VARCHAR(100) UNIQUE NOT NULL,
    cnic_masked VARCHAR(15) NOT NULL, -- Format: 35202-******-1
    cnic_encrypted BYTEA NOT NULL,    -- AES-256 encrypted full CNIC
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    mobile_masked VARCHAR(15) NOT NULL,
    mobile_encrypted BYTEA NOT NULL,
    role VARCHAR(50) NOT NULL,
    office_id UUID NOT NULL REFERENCES offices(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_users_office ON users(office_id);
CREATE INDEX idx_users_role ON users(role);
```

#### 2.3 Supervisees (Probationers & Parolees)
```sql
CREATE TABLE supervisees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    registration_number VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    father_name VARCHAR(150) NOT NULL,
    cnic_masked VARCHAR(15) NOT NULL,
    cnic_encrypted BYTEA NOT NULL,
    gender VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    primary_phone VARCHAR(20),
    emergency_contact VARCHAR(20),
    residential_address TEXT NOT NULL,
    home_location GEOMETRY(Point, 4326),
    supervision_type VARCHAR(30) NOT NULL CHECK (supervision_type IN ('PROBATION', 'PAROLE')),
    current_status VARCHAR(30) NOT NULL CHECK (current_status IN ('ACTIVE', 'COMPLETED', 'REVOKED', 'TRANSFERRED', 'ABSCONDED')),
    device_mode VARCHAR(30) NOT NULL CHECK (device_mode IN ('SMARTPHONE_REGISTERED', 'OFFICER_ASSISTED')),
    base_photo_s3_key VARCHAR(255) NOT NULL,
    primary_officer_id UUID NOT NULL REFERENCES users(id),
    office_id UUID NOT NULL REFERENCES offices(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_supervisees_officer ON supervisees(primary_officer_id);
CREATE INDEX idx_supervisees_status ON supervisees(current_status);
```

#### 2.4 Supervision Orders & Conditions
```sql
CREATE TABLE supervision_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES supervisees(id),
    court_or_board_name VARCHAR(150) NOT NULL,
    case_reference_number VARCHAR(100) NOT NULL,
    offense_category VARCHAR(150) NOT NULL,
    order_start_date DATE NOT NULL,
    order_end_date DATE NOT NULL,
    mandatory_checkin_frequency VARCHAR(30) NOT NULL CHECK (mandatory_checkin_frequency IN ('DAILY', 'WEEKLY', 'BIWEEKLY', 'MONTHLY')),
    conditions_json JSONB NOT NULL, -- List of specific legal terms
    order_document_s3_key VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_orders_supervisee ON supervision_orders(supervisee_id);
```

#### 2.5 Digital Check-Ins & Photos
```sql
CREATE TABLE digital_checkins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES supervisees(id),
    schedule_id UUID,
    checkin_timestamp TIMESTAMPTZ NOT NULL,
    checkin_type VARCHAR(30) NOT NULL CHECK (checkin_type IN ('SELF_MOBILE', 'OFFICER_ASSISTED', 'OFFICE_KIOSK')),
    location GEOMETRY(Point, 4326) NOT NULL,
    location_accuracy_meters NUMERIC(6,2),
    photo_s3_key VARCHAR(255),
    receipt_code VARCHAR(64) NOT NULL UNIQUE,
    receipt_signature VARCHAR(256) NOT NULL,
    verification_status VARCHAR(30) NOT NULL DEFAULT 'PENDING_REVIEW',
    is_synced_offline BOOLEAN DEFAULT FALSE,
    client_created_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_checkins_supervisee ON digital_checkins(supervisee_id);
CREATE INDEX idx_checkins_spatial ON digital_checkins USING GIST(location);
```

#### 2.6 Risk & Needs Assessments (RNA)
```sql
CREATE TABLE rna_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES supervisees(id),
    assessing_officer_id UUID NOT NULL REFERENCES users(id),
    assessment_date DATE NOT NULL,
    risk_score_total INT NOT NULL,
    risk_category VARCHAR(20) NOT NULL CHECK (risk_category IN ('LOW', 'MEDIUM', 'HIGH')),
    criminogenic_needs_json JSONB NOT NULL,
    recommendations TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_rna_supervisee ON rna_assessments(supervisee_id);
```

#### 2.7 Violations & Supervisory Reviews
```sql
CREATE TABLE violation_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES supervisees(id),
    reporting_officer_id UUID NOT NULL REFERENCES users(id),
    violation_type VARCHAR(50) NOT NULL,
    violation_date DATE NOT NULL,
    description TEXT NOT NULL,
    supervisee_statement TEXT,
    supervisor_approval_status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (supervisor_approval_status IN ('PENDING', 'APPROVED', 'REJECTED', 'ADDITIONAL_INFO_REQUESTED')),
    approving_supervisor_id UUID REFERENCES users(id),
    approval_comments TEXT,
    approval_timestamp TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_violations_supervisee ON violation_records(supervisee_id);
```

#### 2.8 Immutable Audit Log Table
```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    keycloak_user_id VARCHAR(100),
    user_role VARCHAR(50) NOT NULL,
    action_name VARCHAR(100) NOT NULL, -- e.g. VIEW_CASE, CREATE_CHECKIN, EXPORT_REPORT
    target_entity VARCHAR(100) NOT NULL,
    target_entity_id UUID,
    ip_address INET NOT NULL,
    user_agent TEXT,
    changes_diff JSONB, -- Previous vs new state
    previous_record_hash VARCHAR(64) NOT NULL, -- HMAC-SHA256 Chaining
    current_record_hash VARCHAR(64) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_action ON audit_logs(action_name);
CREATE INDEX idx_audit_target ON audit_logs(target_entity, target_entity_id);
```
