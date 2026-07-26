# Punjab Digital Community Supervision System (PDCSS)
## Functional Requirements Specification

### 1. Overview of 23 Core Functional Modules

#### FR-01: User & Role Management
- **FR-01.1**: The system shall support Keycloak OIDC/OAuth2 authentication with RBAC and ABAC for all 10 user roles.
- **FR-01.2**: User accounts must support disabling, session revocation, and device deregistration by authorized administrators.
- **FR-01.3**: Passwords must meet departmental complexity standards (managed by Keycloak). Fallback local password storage, if used during development, must use Argon2id hashing.

#### FR-02: Office Hierarchy Management
- **FR-02.1**: System shall maintain a 4-tier organizational tree: Directorate (HQ) -> Division (9 regions in Punjab) -> District (36 districts) -> Tehsil (sub-districts).
- **FR-02.2**: Each officer account shall be bound to one or more Tehsils/Districts for data access scoping.

#### FR-03: Supervisee Registration & Officer-Led Enrolment
- **FR-03.1**: Probation/Parole Officers shall enroll supervisees by recording CNIC, full name, father's name, primary address, contact number, emergency contact, offense category, court case number, and supervision order details.
- **FR-03.2**: Enrolment shall require capturing a live base photograph using the officer app.
- **FR-03.3**: Enrolment shall capture smartphone pairing status (Registered Smartphone vs. Officer-Assisted / Non-Smartphone Mode).

#### FR-04: Supervision Orders & Conditions
- **FR-04.1**: System shall store formal supervision conditions (e.g., check-in frequency, curfew, travel restrictions, mandatory rehabilitation/vocational attendance, employment maintenance).
- **FR-04.2**: Order modifications shall require supervisory officer approval and generate immutable history logs.

#### FR-05: Case Assignment & Transfer
- **FR-05.1**: System shall assign supervisees to a primary Probation or Parole Officer.
- **FR-05.2**: System shall support inter-district and intra-district case transfer workflows with initiation, supervisory approval, and receiving officer acceptance.

#### FR-06: Appointment Scheduling
- **FR-06.1**: Officers shall schedule recurring or one-off office visits, field visits, or counseling sessions.
- **FR-06.2**: Supervisees shall receive localized push notifications and SMS reminders prior to scheduled appointments.

#### FR-07: Digital Check-Ins
- **FR-07.1**: Supervisees shall complete scheduled check-ins via their Android app within authorized time windows.
- **FR-07.2**: The system shall issue a digital submission receipt containing a unique receipt code, timestamp, and cryptographic hash upon successful check-in.

#### FR-08: Live Photograph Capture During Selected Check-Ins
- **FR-08.1**: Selected or randomized check-ins shall require capturing a live photo through the in-app camera.
- **FR-08.2**: System shall prevent uploading pre-existing gallery images or stored files.

#### FR-09: Location Capture During Lawful Supervision Events Only
- **FR-09.1**: System shall capture precise GPS coordinates (`latitude`, `longitude`, `accuracy`) **ONLY** when a user actively presses the submit button for a check-in or when an officer logs a field visit.
- **FR-09.2**: System **SHALL NOT** perform background location tracking, geofence monitoring, or periodic location streaming.

#### FR-10: Multi-Channel Contacts Logging
- **FR-10.1**: Officers shall record contact logs categorized as Office Visit, Telephone Contact, Digital Check-in, or Field Contact.
- **FR-10.2**: Field contacts shall allow recording officer observations, home environment notes, and supervisor notes.

#### FR-11: Risk & Needs Assessments (RNA)
- **FR-11.1**: Officers shall complete standardized Risk and Needs Assessments evaluating criminal history, employment stability, family support, substance abuse, and psychological indicators.
- **FR-11.2**: RNA scoring shall categorize risk tier (Low, Medium, High) to guide supervision intensity.

#### FR-12: Individual Supervision & Rehabilitation Plans (ISRP)
- **FR-12.1**: System shall enable generating an ISRP based on RNA results, defining SMART goals, intervention steps, target dates, and assigned rehabilitation resources.

#### FR-13: Referrals & Intervention Tracking
- **FR-13.1**: System shall track referrals to government/NGO partners (TEVTA vocational institutes, anti-narcotics rehabilitation clinics, health centers, employment exchanges).
- **FR-13.2**: Rehab officers shall record attendance, progress milestones, and completion certificates.

#### FR-14: Alerts & Officer Review
- **FR-14.1**: System shall generate actionable alerts for officers upon missed check-ins, upcoming appointments, pending transfers, or overdue RNA reviews.
- **FR-14.2**: Alerts shall require officer acknowledgement and resolution logging.

#### FR-15: Violation Recording & Supervisory Approval
- **FR-15.1**: Officers shall record formal non-compliance incidents (e.g., unexcused missed check-ins, failed drug screen, curfew breach).
- **FR-15.2**: System shall require District Supervisory Officer approval before finalizing a violation report. **NO AUTOMATED SANCTIONS.**

#### FR-16: Documents & Attachments Management
- **FR-16.1**: System shall upload and store court orders, release certificates, CNIC copies, medical reports, and field photos in MinIO S3 storage.
- **FR-16.2**: All uploaded files shall be sanitized, virus-scanned, and stored with encrypted UUID paths.

#### FR-17: Complaints & Assistance Requests
- **FR-17.1**: Supervisees shall submit grievances, requests for schedule changes, or assistance requests via their app.
- **FR-17.2**: Designated supervisory officers shall review, assign, and respond to complaints within defined timelines.

#### FR-18: Multi-Channel Notifications
- **FR-18.1**: System shall support push notifications (Firebase Cloud Messaging / Web Push) and SMS alerts (via PITB/Government SMS Gateway) in English and Urdu.

#### FR-19: District, Division & Provincial Dashboards
- **FR-19.1**: Interactive web dashboards displaying real-time compliance percentages, active caseloads, overdue check-ins, pending transfers, and rehabilitation referral rates.

#### FR-20: Reports & Authorised Data Exports
- **FR-20.1**: Authorized users shall generate PDF compliance reports, case summary dossiers, and statistical CSV exports with masked PII where required.

#### FR-21: Immutable Audit Logging
- **FR-21.1**: Every creation, view, update, deletion, authentication attempt, data export, and admin configuration change shall be written to an immutable audit table with cryptographic HMAC chaining.

#### FR-22: Offline Operation & Synchronization
- **FR-22.1**: Mobile apps shall operate fully offline using local encrypted SQLite/Drift databases.
- **FR-22.2**: System shall automatically synchronize pending check-ins, contact notes, and photos when cellular/Wi-Fi connectivity is restored.

#### FR-23: Localisation & Language Support
- **FR-23.1**: Mobile apps and web portal shall support complete English and Urdu interfaces, including Right-to-Left (RTL) layout switching and localized numerical formatting.
