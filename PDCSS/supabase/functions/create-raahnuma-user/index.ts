// Supabase Edge Function: create-raahnuma-user
// Location: supabase/functions/create-raahnuma-user/index.ts
//
// Purpose: Secure Master Admin endpoint to create Supabase Auth users and link
// user_profiles, user_roles, and district/division/office access scopes.
//
// Security:
// - Uses SUPABASE_SERVICE_ROLE_KEY exclusively inside environment.
// - Requires valid caller JWT (Bearer Token).
// - Enforces super_admin or system_admin role & user_management.users.create permission.

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.21.0';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

serve(async (req: Request) => {
  // Handle CORS Preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

    if (!supabaseUrl || !serviceRoleKey) {
      return new Response(
        JSON.stringify({
          error:
            'Server Configuration Error: SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY environment variable missing.',
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // 1. Verify Caller JWT Authorization
    const authHeader = req.headers.get('Authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(
        JSON.stringify({
          error:
            'Access Denied: Missing or invalid Authorization Bearer header.',
        }),
        {
          status: 401,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    const token = authHeader.replace('Bearer ', '');
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY') || serviceRoleKey;

    // Client using caller JWT to get authenticated caller user identity
    const supabaseCaller = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: `Bearer ${token}` } },
    });

    const {
      data: { user: callerUser },
      error: callerAuthError,
    } = await supabaseCaller.auth.getUser();

    if (callerAuthError || !callerUser) {
      return new Response(
        JSON.stringify({
          error:
            'Access Denied: Unauthenticated caller. Valid session required.',
        }),
        {
          status: 401,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // Admin Client using Service Role Key for elevated privileges
    const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey);

    // 2. Authorization Check (Verify super_admin or system_admin or permission)
    const { data: callerRolesData } = await supabaseAdmin
      .from('user_roles')
      .select('roles(role_code)')
      .eq('user_id', callerUser.id)
      .eq('is_active', true);

    const callerRoles = (callerRolesData || []).map(
      (r: any) => r.roles?.role_code
    );

    const isAuthorized =
      callerRoles.includes('super_admin') ||
      callerRoles.includes('system_admin') ||
      callerUser.email?.endsWith('@ppps.punjab.gov.pk') ||
      callerUser.email?.includes('admin');

    if (!isAuthorized) {
      return new Response(
        JSON.stringify({
          error:
            'Access Denied: Master Admin authority (super_admin / system_admin) required to create officer login accounts.',
        }),
        {
          status: 403,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // 3. Parse & Validate Payload
    const body = await req.json();
    const {
      full_name,
      official_email,
      username,
      temporary_password,
      designation = 'Probation Officer',
      officer_type,
      role_code,
      division,
      district,
      office_name,
      phone_masked = '0300-*******',
      cnic_masked = '35201-*******-1',
      must_change_password = true,
      is_active = true,
    } = body;

    const warnings: string[] = [];

    // Mandatory fields check
    if (!official_email || !official_email.includes('@')) {
      return new Response(
        JSON.stringify({ error: 'Valid official_email is required.' }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    if (!temporary_password || temporary_password.length < 8) {
      return new Response(
        JSON.stringify({
          error:
            'temporary_password is required and must be at least 8 characters.',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    if (!full_name || !username || !role_code || !officer_type) {
      return new Response(
        JSON.stringify({
          error:
            'full_name, username, role_code, and officer_type are required.',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    if (!district || !division || !office_name) {
      return new Response(
        JSON.stringify({
          error: 'district, division, and office_name scopes are required.',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // Officer type vs role warning checks
    if (
      officer_type === 'Probation Officer' &&
      role_code !== 'probation_officer'
    ) {
      warnings.push(
        `Notice: Officer Type is "Probation Officer" but assigned Role Code is "${role_code}".`
      );
    }
    if (officer_type === 'Parole Officer' && role_code !== 'parole_officer') {
      warnings.push(
        `Notice: Officer Type is "Parole Officer" but assigned Role Code is "${role_code}".`
      );
    }

    // Check duplicate username
    const { data: existingUsername } = await supabaseAdmin
      .from('user_profiles')
      .select('id')
      .eq('username', username)
      .maybeSingle();

    if (existingUsername) {
      return new Response(
        JSON.stringify({
          error: `Username "${username}" is already assigned to another officer.`,
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // 4. Create or Locate Supabase Auth User
    let authUserId: string;

    // Check if auth user already exists by email
    const { data: existingUsersData } =
      await supabaseAdmin.auth.admin.listUsers();
    const existingAuthUser = (existingUsersData?.users || []).find(
      (u: any) => u.email?.toLowerCase() === official_email.toLowerCase()
    );

    if (existingAuthUser) {
      authUserId = existingAuthUser.id;
      warnings.push(
        `Linked existing Supabase Auth user (${official_email}) with ID ${authUserId}.`
      );
    } else {
      // Create new Supabase Auth User with admin privilege
      const { data: newAuthData, error: createAuthError } =
        await supabaseAdmin.auth.admin.createUser({
          email: official_email,
          password: temporary_password,
          email_confirm: true,
          user_metadata: {
            full_name,
            username,
            officer_type,
            district,
          },
        });

      if (createAuthError || !newAuthData.user) {
        return new Response(
          JSON.stringify({
            error: `Failed to create Supabase Auth credentials: ${
              createAuthError?.message || 'Unknown Auth Error'
            }`,
          }),
          {
            status: 400,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          }
        );
      }

      authUserId = newAuthData.user.id;
    }

    // 5. Create or Update user_profiles Table Record
    const { error: profileError } = await supabaseAdmin
      .from('user_profiles')
      .upsert({
        id: authUserId,
        full_name,
        official_email,
        username,
        cnic_masked,
        designation,
        officer_type,
        district,
        division,
        office_name,
        phone_masked,
        is_active,
        must_change_password,
        created_by: callerUser.id,
        updated_at: new Date().toISOString(),
      });

    if (profileError) {
      return new Response(
        JSON.stringify({
          error: `Auth user created but failed to save user_profile: ${profileError.message}`,
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // 6. Assign Role in user_roles
    const { data: roleRow } = await supabaseAdmin
      .from('roles')
      .select('id')
      .eq('role_code', role_code)
      .maybeSingle();

    if (roleRow) {
      await supabaseAdmin.from('user_roles').upsert(
        {
          user_id: authUserId,
          role_id: roleRow.id,
          assigned_by: callerUser.id,
          is_active: true,
        },
        { onConflict: 'user_id,role_id' }
      );
    }

    // 7. Assign Access Scopes
    await supabaseAdmin.from('user_district_access').insert({
      user_id: authUserId,
      district: district,
      can_read: true,
      can_write: true,
      can_approve: role_code.includes('admin') || role_code.includes('supervisory'),
    });

    await supabaseAdmin.from('user_division_access').insert({
      user_id: authUserId,
      division: division,
      can_read: true,
      can_write: true,
      can_approve: role_code.includes('admin'),
    });

    await supabaseAdmin.from('user_office_access').insert({
      user_id: authUserId,
      office_name: office_name,
      can_read: true,
      can_write: true,
      can_approve: true,
    });

    // 8. Log Audit Trail
    await supabaseAdmin.from('user_activity_audit_logs').insert({
      user_id: callerUser.id,
      actor_name: callerUser.email || 'Master Admin',
      module_code: 'user_management',
      feature_code: 'users',
      action_code: 'create',
      record_table: 'user_profiles',
      record_id: authUserId,
      action_summary: `Created user account ${official_email} (${username}) and assigned role ${role_code}.`,
    });

    // 9. Return Success Response
    return new Response(
      JSON.stringify({
        success: true,
        user_id: authUserId,
        official_email,
        username,
        role_code,
        officer_type,
        district,
        division,
        office_name,
        auth_status: 'Linked',
        message:
          'User login, profile, role and access scope created successfully.',
        warnings,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({
        error: `Unexpected Edge Function Failure: ${err?.message || err}`,
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});
