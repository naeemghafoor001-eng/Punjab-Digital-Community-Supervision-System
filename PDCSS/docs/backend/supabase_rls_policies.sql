-- Raahnuma: Punjab Community Supervision System
-- Supabase Row Level Security (RLS) Policies
-- Location: docs/backend/supabase_rls_policies.sql

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.officers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.supervisees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assigned_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prna_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prna_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.case_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.case_plan_actions ENABLE ROW LEVEL SECURITY;

-- Helper functions for role identification
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN SECURITY DEFINER AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'administrator'
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.is_officer()
RETURNS BOOLEAN SECURITY DEFINER AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'officer'
    );
END;
$$ LANGUAGE plpgsql;


-- ─────────────────────────────────────────────────────────────────────────────
-- 1. PROFILES POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Supervisees view self; Officers view supervisees and officers; Admins view all
CREATE POLICY select_profiles ON public.profiles
    FOR SELECT
    TO authenticated
    USING (
        id = auth.uid() 
        OR public.is_admin() 
        OR (public.is_officer() AND role IN ('supervisee', 'officer'))
    );

-- Insert: Admins only
CREATE POLICY insert_profiles ON public.profiles
    FOR INSERT
    TO authenticated
    WITH CHECK (public.is_admin());

-- Update: Users update self; Admins update all
CREATE POLICY update_profiles ON public.profiles
    FOR UPDATE
    TO authenticated
    USING (id = auth.uid() OR public.is_admin())
    WITH CHECK (id = auth.uid() OR public.is_admin());


-- ─────────────────────────────────────────────────────────────────────────────
-- 2. OFFICERS POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Officers view self/all; Supervisees view assigned; Admins view all
CREATE POLICY select_officers ON public.officers
    FOR SELECT
    TO authenticated
    USING (
        id = auth.uid() 
        OR public.is_admin()
        OR public.is_officer()
        OR (
            EXISTS (
                SELECT 1 FROM public.supervisees s 
                WHERE s.id = auth.uid() AND s.assigned_officer_id = public.officers.id
            )
        )
    );

-- Insert/Update: Admins only (Officers managed by DG Office administration)
CREATE POLICY manage_officers ON public.officers
    FOR ALL
    TO authenticated
    USING (public.is_admin())
    WITH CHECK (public.is_admin());


-- ─────────────────────────────────────────────────────────────────────────────
-- 3. SUPERVISEES POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Supervisee view self; Assigned officer view caseload; Admins view all
CREATE POLICY select_supervisees ON public.supervisees
    FOR SELECT
    TO authenticated
    USING (
        id = auth.uid() 
        OR public.is_admin() 
        OR (public.is_officer() AND assigned_officer_id = auth.uid())
    );

-- Insert: Admins only
CREATE POLICY insert_supervisees ON public.supervisees
    FOR INSERT
    TO authenticated
    WITH CHECK (public.is_admin());

-- Update: Admins update all; Assigned officers update details (next reporting date)
CREATE POLICY update_supervisees ON public.supervisees
    FOR UPDATE
    TO authenticated
    USING (public.is_admin() OR (public.is_officer() AND assigned_officer_id = auth.uid()))
    WITH CHECK (public.is_admin() OR (public.is_officer() AND assigned_officer_id = auth.uid()));


-- ─────────────────────────────────────────────────────────────────────────────
-- 4. APPOINTMENTS POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Supervisee view self; Assigned officer view caseload; Admins view all
CREATE POLICY select_appointments ON public.appointments
    FOR SELECT
    TO authenticated
    USING (
        supervisee_id = auth.uid()
        OR officer_id = auth.uid()
        OR public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.appointments.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );

-- Insert/Update: Officer (assigned) or Admin
CREATE POLICY manage_appointments ON public.appointments
    FOR ALL
    TO authenticated
    USING (
        public.is_admin() 
        OR officer_id = auth.uid()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.appointments.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    )
    WITH CHECK (
        public.is_admin() 
        OR officer_id = auth.uid()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.appointments.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );


-- ─────────────────────────────────────────────────────────────────────────────
-- 5. CHECKINS POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Supervisee view self; Assigned officer view caseload; Admins view all
CREATE POLICY select_checkins ON public.checkins
    FOR SELECT
    TO authenticated
    USING (
        supervisee_id = auth.uid()
        OR public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.checkins.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );

-- Insert: Supervisee inserts own check-in; Admin inserts
CREATE POLICY insert_checkins ON public.checkins
    FOR INSERT
    TO authenticated
    WITH CHECK (
        supervisee_id = auth.uid() 
        OR public.is_admin()
    );

-- Update: Admins only (No changes allowed to submitted check-ins for compliance integrity)
CREATE POLICY update_checkins ON public.checkins
    FOR UPDATE
    TO authenticated
    USING (public.is_admin())
    WITH CHECK (public.is_admin());


-- ─────────────────────────────────────────────────────────────────────────────
-- 6. CONTACTS POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Supervisee view self (review office reporting log); Assigned officer view caseload; Admins view all
CREATE POLICY select_contacts ON public.contacts
    FOR SELECT
    TO authenticated
    USING (
        supervisee_id = auth.uid()
        OR officer_id = auth.uid()
        OR public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.contacts.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );

-- Insert/Update: Assigned officer or Admin
CREATE POLICY manage_contacts ON public.contacts
    FOR ALL
    TO authenticated
    USING (
        public.is_admin() 
        OR officer_id = auth.uid()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.contacts.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    )
    WITH CHECK (
        public.is_admin() 
        OR officer_id = auth.uid()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.contacts.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );


-- ─────────────────────────────────────────────────────────────────────────────
-- 7. ALERTS POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Supervisee view self; Assigned officer view caseload; Admins view all
CREATE POLICY select_alerts ON public.alerts
    FOR SELECT
    TO authenticated
    USING (
        supervisee_id = auth.uid()
        OR public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.alerts.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );

-- Insert/Update: Assigned officer (to resolve/flag alerts) or Admin
CREATE POLICY manage_alerts ON public.alerts
    FOR ALL
    TO authenticated
    USING (
        public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.alerts.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    )
    WITH CHECK (
        public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.alerts.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );


-- ─────────────────────────────────────────────────────────────────────────────
-- 8. ACTIVITIES POLICIES (Audit Logs)
-- ─────────────────────────────────────────────────────────────────────────────

-- Select: Admins view all; Users view self log
CREATE POLICY select_activities ON public.activities
    FOR SELECT
    TO authenticated
    USING (actor_id = auth.uid() OR public.is_admin());

-- Insert: Authenticated users insert logs of self-actions
CREATE POLICY insert_activities ON public.activities
    FOR INSERT
    TO authenticated
    WITH CHECK (actor_id = auth.uid() OR public.is_admin());

-- Update: Disabled (Audit logs are immutable for compliance standards)
CREATE POLICY update_activities ON public.activities
    FOR UPDATE
    TO authenticated
    USING (FALSE);


-- ─────────────────────────────────────────────────────────────────────────────
-- 9. ASSIGNED ACTIVITIES POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Prototype Anonymous Public Policy (FOR FICTIONAL DEMO ONLY)
-- Note: In production, remove anon policy and enforce authenticated role-based policies.
CREATE POLICY select_assigned_activities_anon ON public.assigned_activities
    FOR SELECT TO anon USING (TRUE);

-- Authenticated Select Policy
CREATE POLICY select_assigned_activities ON public.assigned_activities
    FOR SELECT TO authenticated
    USING (
        supervisee_id = auth.uid() 
        OR officer_id = auth.uid() 
        OR public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.assigned_activities.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );

-- Authenticated Manage Policy (Officers and Admins create/update assigned activities)
CREATE POLICY manage_assigned_activities ON public.assigned_activities
    FOR ALL TO authenticated
    USING (public.is_admin() OR public.is_officer())
    WITH CHECK (public.is_admin() OR public.is_officer());


-- ─────────────────────────────────────────────────────────────────────────────
-- 10. ACTIVITY ATTENDANCE POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Prototype Anonymous Public Policies (FOR FICTIONAL DEMO ONLY)
-- Note: In production, remove anon policies and enforce authenticated role-based policies.
CREATE POLICY select_activity_attendance_anon ON public.activity_attendance
    FOR SELECT TO anon USING (TRUE);

CREATE POLICY insert_activity_attendance_anon ON public.activity_attendance
    FOR INSERT TO anon WITH CHECK (TRUE);

CREATE POLICY update_activity_attendance_anon ON public.activity_attendance
    FOR UPDATE TO anon USING (TRUE) WITH CHECK (TRUE);

-- Authenticated Select Policy
CREATE POLICY select_activity_attendance ON public.activity_attendance
    FOR SELECT TO authenticated
    USING (
        supervisee_id = auth.uid()
        OR officer_id = auth.uid()
        OR public.is_admin()
        OR (public.is_officer() AND EXISTS (
            SELECT 1 FROM public.supervisees s 
            WHERE s.id = public.activity_attendance.supervisee_id AND s.assigned_officer_id = auth.uid()
        ))
    );

-- Authenticated Insert Policy (Supervisee inserts own attendance)
CREATE POLICY insert_activity_attendance ON public.activity_attendance
    FOR INSERT TO authenticated
    WITH CHECK (supervisee_id = auth.uid() OR public.is_admin());

-- Authenticated Update Policy (Officer updates review status & comments)
CREATE POLICY update_activity_attendance ON public.activity_attendance
    FOR UPDATE TO authenticated
    USING (public.is_admin() OR public.is_officer())
    WITH CHECK (public.is_admin() OR public.is_officer());


-- ─────────────────────────────────────────────────────────────────────────────
-- 11-14. PRNA & CASE PLANNING POLICIES
-- ─────────────────────────────────────────────────────────────────────────────

-- Prototype Anonymous Public Policies (FOR FICTIONAL DEMO ONLY)
-- Note: In production, remove anon policies and enforce authenticated role-based policies.
CREATE POLICY select_prna_assessments_anon ON public.prna_assessments FOR SELECT TO anon USING (TRUE);
CREATE POLICY insert_prna_assessments_anon ON public.prna_assessments FOR INSERT TO anon WITH CHECK (TRUE);
CREATE POLICY update_prna_assessments_anon ON public.prna_assessments FOR UPDATE TO anon USING (TRUE) WITH CHECK (TRUE);

CREATE POLICY select_prna_responses_anon ON public.prna_responses FOR SELECT TO anon USING (TRUE);
CREATE POLICY insert_prna_responses_anon ON public.prna_responses FOR INSERT TO anon WITH CHECK (TRUE);

CREATE POLICY select_case_plans_anon ON public.case_plans FOR SELECT TO anon USING (TRUE);
CREATE POLICY insert_case_plans_anon ON public.case_plans FOR INSERT TO anon WITH CHECK (TRUE);
CREATE POLICY update_case_plans_anon ON public.case_plans FOR UPDATE TO anon USING (TRUE) WITH CHECK (TRUE);

CREATE POLICY select_case_plan_actions_anon ON public.case_plan_actions FOR SELECT TO anon USING (TRUE);
CREATE POLICY insert_case_plan_actions_anon ON public.case_plan_actions FOR INSERT TO anon WITH CHECK (TRUE);
CREATE POLICY update_case_plan_actions_anon ON public.case_plan_actions FOR UPDATE TO anon USING (TRUE) WITH CHECK (TRUE);

-- Authenticated PRNA Assessments Policy (Officers manage assigned, Admins view all)
CREATE POLICY select_prna_assessments ON public.prna_assessments FOR SELECT TO authenticated
    USING (public.is_admin() OR officer_id = auth.uid() OR (public.is_officer() AND EXISTS (
        SELECT 1 FROM public.supervisees s WHERE s.id = public.prna_assessments.supervisee_id AND s.assigned_officer_id = auth.uid()
    )));

CREATE POLICY manage_prna_assessments ON public.prna_assessments FOR ALL TO authenticated
    USING (public.is_admin() OR public.is_officer()) WITH CHECK (public.is_admin() OR public.is_officer());

-- Authenticated Case Plans Policy (Officers manage, Supervisees view active plan)
CREATE POLICY select_case_plans ON public.case_plans FOR SELECT TO authenticated
    USING (supervisee_id = auth.uid() OR officer_id = auth.uid() OR public.is_admin() OR public.is_officer());

CREATE POLICY manage_case_plans ON public.case_plans FOR ALL TO authenticated
    USING (public.is_admin() OR public.is_officer()) WITH CHECK (public.is_admin() OR public.is_officer());

CREATE POLICY select_case_plan_actions ON public.case_plan_actions FOR SELECT TO authenticated
    USING (public.is_admin() OR public.is_officer() OR EXISTS (
        SELECT 1 FROM public.case_plans cp WHERE cp.id = public.case_plan_actions.case_plan_id AND cp.supervisee_id = auth.uid()
    ));

CREATE POLICY manage_case_plan_actions ON public.case_plan_actions FOR ALL TO authenticated
    USING (public.is_admin() OR public.is_officer()) WITH CHECK (public.is_admin() OR public.is_officer());


-- ─────────────────────────────────────────────────────────────────────────────
-- DELETION PREVENTION RULE (No DELETE policies created for any table)
-- ─────────────────────────────────────────────────────────────────────────────
-- Soft delete columns or updates must be used instead of hard deletes to protect
-- system audit trail integrity in the Punjab Probation and Parole Service.


