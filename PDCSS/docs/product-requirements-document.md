# Punjab Digital Community Supervision System (PDCSS)
## Product Requirements Document (PRD)

### 1. Product Overview
PDCSS is a digital community supervision platform designed specifically for the Punjab Probation and Parole Service (PP&PS), Home Department, Government of the Punjab. The platform consists of a backend API server, two mobile applications (Supervisee App & Officer App), and a management web portal.

### 2. User Personas & Target Audiences
1. **Supervisee (Probationer / Parolee)**: Individual placed under community supervision by court order or parole board. Needs simple Urdu UI, clear appointment reminders, check-in submission, and assistance requesting.
2. **Probation Officer**: Supervises court-ordered probationers in a specific Tehsil/District. Needs case monitoring, field visit logging, RNA/ISRP authoring, and check-in validation tools.
3. **Parole Officer**: Supervises executive parolees released from correctional facilities. Manages parole conditions, employment tracking, and compliance reports.
4. **District Supervisory Officer (e.g. Assistant Director / District Officer)**: Oversees all cases within a District. Reviews violation reports, approves case transfers, and reviews district performance metrics.
5. **Divisional / Regional Supervisory Officer (e.g. Deputy Director)**: Monitors multi-district regional performance, allocates staffing resources, and reviews regional trends.
6. **Directorate Monitoring Officer (HQ Monitoring Cell)**: Monitors statewide compliance, tracks system usage, and identifies systemic delays or operational bottlenecks.
7. **Rehabilitation Officer**: Specializes in skills development, psychological counseling, vocational referrals, and social reintegration tracking.
8. **Audit Officer**: Reviews system audit logs, compliance records, and security events for administrative or judicial verification. Strictly read-only access.
9. **System Administrator**: Configures system settings, manages user accounts, configures Keycloak roles, and manages infrastructure. **Strictly prohibited from viewing operational case notes or supervisee PII.**
10. **Director General & Executive Management**: Reads aggregated high-level dashboards, executive reports, and statistical analytics across the province.

### 3. Core Capabilities & Product Features
- **Registration & Officer-Led Enrolment**: Officer verifies identity (CNIC, court order, release certificate), registers demographical data, captures base photograph, and pairs smartphone or marks as officer-assisted mode.
- **Order & Condition Management**: Captures formal legal terms (mandatory check-ins, employment requirements, territorial limits, rehab programs).
- **Scheduled & Ad-Hoc Digital Check-Ins**: Supervisees perform check-ins with location snapshot and optional live photo capture upon prompt.
- **Officer-Assisted Check-In Option**: Enables check-ins for supervisees without smartphones or in low-literacy scenarios via physical office visits or officer mobile device.
- **Risk & Needs Assessment (RNA) & Rehabilitation Plans (ISRP)**: Standardized scoring for risk factors and custom rehabilitation goals with referral tracking.
- **Violation Recording & Supervisory Review**: Multi-step human-in-the-loop workflow for non-compliance recording, officer comments, supervisee response capture, and supervisory decision logging.
- **Offline Operation & Synchronization**: Fully functional mobile experience offline with Drift/SQLite encrypted storage and automatic background delta sync upon connection restoration.
- **Urdu & English Localization**: Complete RTL UI support with clear font choices (e.g., Noto Nastaliq Urdu / Noto Sans Urdu) and simple terminology.

### 4. Key Constraints & Non-Negotiables
- **No Automated Liberty Restrictions**: The system is an auxiliary decision-support tool for officers. Automated revocation of probation/parole is strictly disallowed.
- **No Continuous Location Tracking**: GPS coordinates are requested strictly during user-initiated submission events (check-ins or field visit logs).
- **Open-Source Stack**: Built using Flutter, Dart, Python FastAPI, PostgreSQL/PostGIS, Keycloak, MinIO, Nginx, Docker Compose, and OpenStreetMap components.
- **Data Protection Compliance**: Strict masking of CNIC numbers (e.g., `35202-******-1`) and phone numbers across UI displays except where full unmasked view is explicitly authorized.
