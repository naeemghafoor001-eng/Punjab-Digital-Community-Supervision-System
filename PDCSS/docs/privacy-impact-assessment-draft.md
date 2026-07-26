# Punjab Digital Community Supervision System (PDCSS)
## Privacy Impact Assessment (PIA) - Draft

### 1. Executive Summary & Purpose
The Punjab Digital Community Supervision System (PDCSS) processes sensitive personal data, legal supervision records, geotagged check-in snapshots, and photographic evidence for probationers and parolees across Punjab. This Privacy Impact Assessment (PIA) evaluates data processing risks, privacy safeguards, statutory compliance, and ethical boundaries designed into the PDCSS architecture.

### 2. Data Processing Inventory & Flow

| Data Category | Data Elements Collected | Legal Basis / Purpose | Storage Location | Retention Period |
| :--- | :--- | :--- | :--- | :--- |
| **Supervisee Identity PII** | Full Name, CNIC, Father's Name, DOB, Address, Phone | Identity verification & legal supervision | PostgreSQL (Encrypted at rest) | Active case duration + archival policy (*Requires PP&PS approval*) |
| **Supervision Case Data** | Court order, offense category, probation conditions, assigned officer | Lawful probation/parole order enforcement | PostgreSQL | Active case duration + 10 years (*Requires PP&PS approval*) |
| **Location Snapshots** | Latitude, Longitude, Accuracy, Altitude (Point in Time) | Verification of presence during authorized check-in or field visit | PostgreSQL / PostGIS | 12 months post-checkin (*Requires PP&PS approval*) |
| **Live Check-In Photos** | Image payload captured via camera | Verification of identity during selected check-in | MinIO S3 Object Storage | 6 months post-checkin (*Requires PP&PS approval*) |
| **Audit Logs** | User ID, Role, Action, Timestamp, IP Address, Target ID | Security monitoring & prevention of unauthorized access | Immutable Audit DB Table | 5 years minimum (*Requires PP&PS approval*) |

---

### 3. Key Privacy Safeguards

#### 3.1 Strict Prohibition of Continuous Location Tracking
- **Risk**: Continuous GPS streaming or background geofencing severely infringes on constitutional rights to privacy and mobility under Pakistani law (Article 14 of the Constitution of Pakistan).
- **Safeguard**: PDCSS **does not include** any background location service, persistent GPS listener, or geofence tracking module. Location services are invoked *exclusively* inside the foreground submit button handler for digital check-ins or field contact logs.

#### 3.2 Prior Consent & Clear Explanation Dialogs
- **Risk**: Users granting camera or location permissions without understanding the lawful supervision context.
- **Safeguard**: Mobile applications display an explicit modal dialog in English and Urdu *before* requesting Android runtime permissions. The dialog states:
  > *"Location and camera access are used ONLY at this moment to verify your check-in submission as required by your supervision order. Continuous tracking is never performed."*

#### 3.3 Non-Compulsory Smartphone Ownership & Officer-Assisted Fallback
- **Risk**: Supervisees who cannot afford smartphones or live in off-grid rural areas facing automated non-compliance penalty flags.
- **Safeguard**: System explicitly supports "Officer-Assisted Mode". Supervisees without smartphones complete check-ins during physical office visits or via officer-assisted mobile entry.

#### 3.4 Data Masking & Display Restrictions
- **Risk**: Unnecessary exposure of sensitive CNIC and contact details on management dashboards and officer screens.
- **Safeguard**: CNIC numbers (`35202-1234567-1` -> `35202-******-1`) and phone numbers (`0300-1234567` -> `0300-******7`) are masked by default across UI views. Unmasked views are restricted to assigned officers and require explicit authorization.

#### 3.5 Operational Data Isolation from System Administrators
- **Risk**: IT Infrastructure Administrators viewing confidential probationer case notes, medical history, or rehabilitation logs.
- **Safeguard**: API endpoints serving operational case data enforce backend role checks that reject `ROLE_SYSTEM_ADMIN`. Administrators manage system health, configuration, and Keycloak roles without operational case visibility.

---

### 4. Ethical Boundaries & Prohibition of Automated Liberty Restrictions
- **Rule**: PDCSS is strictly designed as an officer-assistance tool.
- **Constraint**: Algorithmic rules, AI models, or automated scripts **SHALL NOT** determine probation/parole violations, issue legal warnings, alter supervision conditions, or initiate revocation proceedings. Every adverse flag triggers an officer alert requiring human investigation and supervisory sign-off.
