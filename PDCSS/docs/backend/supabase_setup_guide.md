# Raahnuma — Supabase Setup Guide

This guide documents the procedures for configuring the PostgreSQL database schema, Row Level Security (RLS) policies, and fictional seed data on the **Raahnuma** pilot project database.

## Project Details
- **Project Name**: `raahnuma-pilot`
- **Project URL**: `https://whqmwzoqmopgamfacncg.supabase.co`

---

## Step 1: Database Initialization

1. Open your browser and log into the **Supabase Dashboard** at [supabase.com](https://supabase.com).
2. Select the **`raahnuma-pilot`** project.
3. Navigate to the **SQL Editor** tab from the left sidebar.
4. Click **New Query** to create a fresh editor page.
5. Open [supabase_schema.sql](file:///d:/Antigravity/PDCSS/docs/backend/supabase_schema.sql), copy the entire file content, paste it into the editor, and click **Run**.
6. Verify that all 8 tables are created in the `public` schema:
   - `profiles`
   - `officers`
   - `supervisees`
   - `appointments`
   - `checkins`
   - `contacts`
   - `alerts`
   - `activities`

---

## Step 2: Apply Row Level Security (RLS)

By default, RLS is disabled. We must explicitly enable it to restrict data access in restricted pilot environments.

1. Open a new query tab in the Supabase SQL Editor.
2. Copy the content of [supabase_rls_policies.sql](file:///d:/Antigravity/PDCSS/docs/backend/supabase_rls_policies.sql), paste it into the editor, and click **Run**.
3. Go to the **Database** tab -> **Policies** to confirm that RLS is active on all 8 tables and the rules are correctly assigned to the `authenticated` role.
4. Note that anonymous public access is disabled. There are **no DELETE policies** created.

---

## Step 3: Populate Fictional Seed Data

To populate the system with fictional presentation and development profiles (e.g., Tariq Mehmood, Officer Tahir Mahmood):

1. Open a new query tab in the SQL Editor.
2. Copy the content of [supabase_seed_demo.sql](file:///d:/Antigravity/PDCSS/docs/backend/supabase_seed_demo.sql), paste it, and click **Run**.
3. Verify the records by clicking on the **Table Editor** tab on the left and selecting different tables.

---

## Step 4: Environment Variables

When connecting Flutter applications or external backend components, **never** hardcode Supabase keys in the source code or commit them to git repository folders.

1. Create a `.env` file in the root directory of your project (add to `.gitignore`):
   ```env
   SUPABASE_URL="https://whqmwzoqmopgamfacncg.supabase.co"
   SUPABASE_ANON_KEY="your-anon-key-here"
   SUPABASE_SERVICE_ROLE_KEY="your-service-role-key-here"
   ```
2. Fetch the keys in the Supabase dashboard under **Project Settings** -> **API**.
