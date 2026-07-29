-- Raahnuma: Punjab Community Supervision System
-- User Management, Authentication & Role-Based Access Control (RBAC) Schema
-- Location: docs/backend/user_management_schema.sql

-- 1. USER_PROFILES TABLE
-- Extended officer and administrative profile metadata linked to auth.users
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    official_email TEXT,
    username TEXT UNIQUE,
    cnic_masked TEXT,
    designation TEXT,
    officer_type TEXT CONSTRAINT check_user_officer_type CHECK (
        officer_type IN (
            'Probation Officer',
            'Parole Officer',
            'Supervisory Officer',
            'Administrative Officer',
            'System Administrator'
        )
    ),
    district TEXT,
    division TEXT,
    office_name TEXT,
    phone_masked TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    must_change_password BOOLEAN DEFAULT FALSE,
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. ROLES TABLE
-- System and custom administrative role definitions
CREATE TABLE IF NOT EXISTS public.roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_code TEXT UNIQUE NOT NULL,
    role_name TEXT NOT NULL,
    role_description TEXT,
    role_level INTEGER DEFAULT 10,
    is_system_role BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. PERMISSIONS TABLE
-- Granular module, sub-feature, and action permission library
CREATE TABLE IF NOT EXISTS public.permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_code TEXT NOT NULL,
    module_name TEXT NOT NULL,
    feature_code TEXT NOT NULL,
    feature_name TEXT NOT NULL,
    action_code TEXT NOT NULL,
    permission_code TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. ROLE_PERMISSIONS TABLE
-- Mapping between roles and permissions
CREATE TABLE IF NOT EXISTS public.role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES public.roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES public.permissions(id) ON DELETE CASCADE,
    allowed BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(role_id, permission_id)
);

-- 5. USER_ROLES TABLE
-- Active roles assigned to users
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES public.roles(id) ON DELETE CASCADE,
    assigned_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    assigned_at TIMESTAMPTZ DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE(user_id, role_id)
);

-- 6. USER_DISTRICT_ACCESS TABLE
-- Explicit district-level data access permissions
CREATE TABLE IF NOT EXISTS public.user_district_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    district TEXT NOT NULL,
    can_read BOOLEAN DEFAULT TRUE,
    can_write BOOLEAN DEFAULT FALSE,
    can_approve BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. USER_DIVISION_ACCESS TABLE
-- Explicit division-level data access permissions
CREATE TABLE IF NOT EXISTS public.user_division_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    division TEXT NOT NULL,
    can_read BOOLEAN DEFAULT TRUE,
    can_write BOOLEAN DEFAULT FALSE,
    can_approve BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. USER_OFFICE_ACCESS TABLE
-- Explicit office-level data access permissions
CREATE TABLE IF NOT EXISTS public.user_office_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    office_name TEXT NOT NULL,
    can_read BOOLEAN DEFAULT TRUE,
    can_write BOOLEAN DEFAULT FALSE,
    can_approve BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. LOGIN_AUDIT_LOGS TABLE
-- Security audit trail for authentication attempts
CREATE TABLE IF NOT EXISTS public.login_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    username_or_email TEXT NOT NULL,
    login_status TEXT NOT NULL CONSTRAINT check_login_status CHECK (
        login_status IN ('Success', 'Failed', 'Locked', 'Logged Out')
    ),
    ip_address TEXT,
    user_agent TEXT,
    failure_reason TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. USER_ACTIVITY_AUDIT_LOGS TABLE
-- Comprehensive audit trail for system configuration and RBAC changes
CREATE TABLE IF NOT EXISTS public.user_activity_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    actor_name TEXT NOT NULL,
    module_code TEXT NOT NULL,
    feature_code TEXT NOT NULL,
    action_code TEXT NOT NULL,
    record_table TEXT,
    record_id TEXT,
    action_summary TEXT NOT NULL,
    old_value JSONB,
    new_value JSONB,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance & audit lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_username ON public.user_profiles(username);
CREATE INDEX IF NOT EXISTS idx_user_profiles_district ON public.user_profiles(district);
CREATE INDEX IF NOT EXISTS idx_user_roles_user ON public.user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON public.user_roles(role_id);
CREATE INDEX IF NOT EXISTS idx_role_permissions_role ON public.role_permissions(role_id);
CREATE INDEX IF NOT EXISTS idx_login_audit_logs_user ON public.login_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_login_audit_logs_created ON public.login_audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_user_activity_audit_user ON public.user_activity_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_audit_module ON public.user_activity_audit_logs(module_code);
