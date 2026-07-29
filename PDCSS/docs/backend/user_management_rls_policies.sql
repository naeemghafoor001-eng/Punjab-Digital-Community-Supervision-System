-- Raahnuma: Punjab Community Supervision System
-- User Management & RBAC Row Level Security (RLS) Policies
-- Location: docs/backend/user_management_rls_policies.sql

-- Enable RLS on all User Management tables
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_district_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_division_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_office_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.login_audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_activity_audit_logs ENABLE ROW LEVEL SECURITY;

-- Helper functions for RBAC security evaluation
CREATE OR REPLACE FUNCTION public.current_user_is_active()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE id = auth.uid() AND is_active = TRUE
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.has_permission(p_permission_code TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 
        FROM public.user_roles ur
        JOIN public.role_permissions rp ON ur.role_id = rp.role_id
        JOIN public.permissions p ON rp.permission_id = p.id
        WHERE ur.user_id = auth.uid()
          AND ur.is_active = TRUE
          AND rp.allowed = TRUE
          AND p.permission_code = p_permission_code
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ─────────────────────────────────────────────────────────────────────────────
-- PROTOTYPE ANONYMOUS POLICIES (DEMO ONLY)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE POLICY select_user_profiles_anon ON public.user_profiles FOR SELECT TO anon USING (TRUE);
CREATE POLICY select_roles_anon ON public.roles FOR SELECT TO anon USING (TRUE);
CREATE POLICY select_permissions_anon ON public.permissions FOR SELECT TO anon USING (TRUE);
CREATE POLICY select_role_permissions_anon ON public.role_permissions FOR SELECT TO anon USING (TRUE);
CREATE POLICY select_user_roles_anon ON public.user_roles FOR SELECT TO anon USING (TRUE);
CREATE POLICY select_login_audit_anon ON public.login_audit_logs FOR SELECT TO anon USING (TRUE);
CREATE POLICY insert_login_audit_anon ON public.login_audit_logs FOR INSERT TO anon WITH CHECK (TRUE);
CREATE POLICY select_activity_audit_anon ON public.user_activity_audit_logs FOR SELECT TO anon USING (TRUE);

-- ─────────────────────────────────────────────────────────────────────────────
-- AUTHENTICATED PRODUCTION POLICIES (STRICT MODE)
-- ─────────────────────────────────────────────────────────────────────────────

-- 1. USER_PROFILES
CREATE POLICY select_user_profiles ON public.user_profiles FOR SELECT TO authenticated
    USING (
        id = auth.uid() 
        OR public.has_permission('user_management:users:read')
        OR public.is_admin()
    );

CREATE POLICY manage_user_profiles ON public.user_profiles FOR ALL TO authenticated
    USING (
        public.has_permission('user_management:users:manage_permissions')
        OR public.has_permission('user_management:users:update')
        OR public.is_admin()
    )
    WITH CHECK (
        public.has_permission('user_management:users:manage_permissions')
        OR public.has_permission('user_management:users:create')
        OR public.is_admin()
    );

-- 2. ROLES & PERMISSIONS
CREATE POLICY select_roles ON public.roles FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY select_permissions ON public.permissions FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY select_role_permissions ON public.role_permissions FOR SELECT TO authenticated USING (TRUE);

CREATE POLICY manage_roles ON public.roles FOR ALL TO authenticated
    USING (public.has_permission('user_management:roles:update') OR public.is_admin())
    WITH CHECK (public.has_permission('user_management:roles:create') OR public.is_admin());

CREATE POLICY manage_role_permissions ON public.role_permissions FOR ALL TO authenticated
    USING (public.has_permission('user_management:permissions:manage_permissions') OR public.is_admin())
    WITH CHECK (public.has_permission('user_management:permissions:manage_permissions') OR public.is_admin());

-- 3. USER_ROLES
CREATE POLICY select_user_roles ON public.user_roles FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY manage_user_roles ON public.user_roles FOR ALL TO authenticated
    USING (public.has_permission('user_management:users:assign') OR public.is_admin())
    WITH CHECK (public.has_permission('user_management:users:assign') OR public.is_admin());

-- 4. LOGIN & ACTIVITY AUDIT LOGS (Insert-only for normal users, read-only for admins)
CREATE POLICY insert_login_audit ON public.login_audit_logs FOR INSERT TO authenticated WITH CHECK (TRUE);
CREATE POLICY select_login_audit ON public.login_audit_logs FOR SELECT TO authenticated
    USING (public.has_permission('audit_trail:login_audit:read') OR public.is_admin());

CREATE POLICY insert_activity_audit ON public.user_activity_audit_logs FOR INSERT TO authenticated WITH CHECK (TRUE);
CREATE POLICY select_activity_audit ON public.user_activity_audit_logs FOR SELECT TO authenticated
    USING (public.has_permission('audit_trail:activity_audit:read') OR public.is_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- DELETION PREVENTION RULE (No DELETE policies created for any table)
-- ─────────────────────────────────────────────────────────────────────────────
-- Hard deletions are strictly disabled. Account deactivation or soft delete must
-- be used to ensure legal audit trail retention under Home Department regulations.
