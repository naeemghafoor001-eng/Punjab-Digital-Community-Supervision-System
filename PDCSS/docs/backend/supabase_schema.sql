-- Raahnuma: Punjab Community Supervision System
-- Supabase PostgreSQL Database Schema
-- Location: docs/backend/supabase_schema.sql

-- Enable uuid-ossp / pgcrypto for UUID generation
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. PROFILES TABLE
-- Extends Supabase auth.users to assign roles and manage names
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL CONSTRAINT check_profile_role CHECK (role IN ('supervisee', 'officer', 'administrator')),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. OFFICERS TABLE
-- Tracks official details of probation and parole officers
CREATE TABLE public.officers (
    id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    designation TEXT NOT NULL CONSTRAINT check_officer_designation CHECK (
        designation IN ('Probation Officer', 'Parole Officer', 'Assistant Director', 'District Officer', 'Deputy Director', 'Director', 'Director General')
    ),
    district TEXT NOT NULL,
    office_address TEXT NOT NULL,
    badge_number TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'Active' CONSTRAINT check_officer_status CHECK (status IN ('Active', 'Suspended', 'Retired')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. SUPERVISEES TABLE
-- Tracks details of individuals under supervision
CREATE TABLE public.supervisees (
    id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    cnic_masked TEXT NOT NULL CONSTRAINT check_cnic_masked CHECK (cnic_masked ~ '^\d{5}-[xX]{7}-\d$'), -- Enforces 35201-xxxxxxx-x style masks
    case_number TEXT UNIQUE NOT NULL,
    supervision_category TEXT NOT NULL CONSTRAINT check_supervision_category CHECK (supervision_category IN ('Probation Order', 'Parole Release')),
    assigned_officer_id UUID REFERENCES public.officers(id) ON DELETE SET NULL,
    next_reporting_date DATE,
    supervision_start_date DATE NOT NULL,
    supervision_end_date DATE NOT NULL,
    compliance_status TEXT NOT NULL DEFAULT 'Compliant' CONSTRAINT check_compliance_status CHECK (compliance_status IN ('Compliant', 'Non-Compliant', 'Under Review')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. APPOINTMENTS TABLE
-- Tracks scheduled meetings between officers and supervisees
CREATE TABLE public.appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES public.supervisees(id) ON DELETE CASCADE,
    officer_id UUID NOT NULL REFERENCES public.officers(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    scheduled_time TIMESTAMPTZ NOT NULL,
    location TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Upcoming' CONSTRAINT check_appointment_status CHECK (status IN ('Upcoming', 'Completed', 'Cancelled', 'No-Show')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. CHECKINS TABLE
-- Records digital check-in attempts by supervisees
CREATE TABLE public.checkins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES public.supervisees(id) ON DELETE CASCADE,
    scheduled_reporting_date DATE NOT NULL,
    receipt_number TEXT UNIQUE NOT NULL,
    identity_confirmed BOOLEAN NOT NULL CONSTRAINT check_identity_confirmed CHECK (identity_confirmed = TRUE),
    residing_at_address BOOLEAN NOT NULL,
    changed_employment BOOLEAN NOT NULL,
    need_assistance BOOLEAN NOT NULL,
    complying_conditions BOOLEAN NOT NULL,
    submitted_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. CONTACTS TABLE
-- Records official physical, telephone, and home contact records by officers
CREATE TABLE public.contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES public.supervisees(id) ON DELETE CASCADE,
    officer_id UUID NOT NULL REFERENCES public.officers(id) ON DELETE CASCADE,
    contact_type TEXT NOT NULL CONSTRAINT check_contact_type CHECK (
        contact_type IN ('Office Visit', 'Telephone Contact', 'Home Visit', 'Workplace Visit', 'Digital Check-In Review', 'Family Contact')
    ),
    contact_date DATE NOT NULL,
    notes TEXT,
    outcome TEXT NOT NULL CONSTRAINT check_contact_outcome CHECK (outcome IN ('Satisfactory', 'Unsatisfactory', 'Action Required', 'Pending Clarification')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. ALERTS TABLE
-- Tracks violations and supervision anomalies
CREATE TABLE public.alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supervisee_id UUID NOT NULL REFERENCES public.supervisees(id) ON DELETE CASCADE,
    category TEXT NOT NULL CONSTRAINT check_alert_category CHECK (
        category IN ('Missed Check-In', 'Missed Appointment', 'Address Deviation', 'Assessment Overdue', 'Order Expiry Nearing')
    ),
    severity TEXT NOT NULL CONSTRAINT check_alert_severity CHECK (severity IN ('Info', 'Pending Review', 'Overdue', 'Violation')),
    description TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Active' CONSTRAINT check_alert_status CHECK (status IN ('Active', 'In Review', 'Resolved')),
    resolved_at TIMESTAMPTZ,
    resolved_by UUID REFERENCES public.officers(id) ON DELETE SET NULL,
    resolution_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. ACTIVITIES TABLE
-- System event audit log (demonstrating log integrity tracking)
CREATE TABLE public.activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    event_type TEXT NOT NULL,
    description TEXT NOT NULL,
    ip_address TEXT,
    user_agent TEXT,
    integrity_hash TEXT, -- SHA-256 integrity check chain simulation
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance queries
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_supervisees_assigned_officer ON public.supervisees(assigned_officer_id);
CREATE INDEX idx_appointments_supervisee ON public.appointments(supervisee_id);
CREATE INDEX idx_checkins_supervisee ON public.checkins(supervisee_id);
CREATE INDEX idx_contacts_supervisee ON public.contacts(supervisee_id);
CREATE INDEX idx_alerts_supervisee ON public.alerts(supervisee_id);
CREATE INDEX idx_activities_actor ON public.activities(actor_id);
