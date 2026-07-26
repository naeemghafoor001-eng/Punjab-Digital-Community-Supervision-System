# Punjab Digital Community Supervision System (PDCSS)
## Assumptions and Open Questions

### 1. Key Assumptions

#### Technical & Infrastructure Assumptions
1. **Connectivity Environment**: Supervisees and officers operate in varying network conditions across Punjab, ranging from high-speed 4G in major urban centers (Lahore, Rawalpindi, Multan) to intermittent 2G/3G or total blackout areas in rural Tehsils. The system must prioritize offline-first mobile architecture.
2. **Device Hardware**: Officers will be provided standard enterprise Android smartphones running Android 8.0 (API level 26) or higher. Supervisees who own smartphones will use low-to-mid range Android devices.
3. **Server Infrastructure**: The Home Department / PP&PS will host PDCSS within a secure government data center (e.g., Punjab Information Technology Board - PITB Data Center) with private cloud infrastructure, Nginx reverse proxies, containerized Docker deployments, and PostgreSQL database clusters.

#### Operational & Organisational Assumptions
1. **Human Decision-Making**: Probation and Parole Officers remain legally responsible for all supervision reports, violation recommendations, and rehabilitation assessments.
2. **Bilingual Competency**: Officers possess functional literacy in both English (for formal administrative reporting) and Urdu (for field operations and supervisee communication).

---

### 2. Decisions Requiring PP&PS Legal or Administrative Approval

The following items cannot be decided unilaterally by the technical team and require explicit review, formal policy directives, or legal sign-off from the Punjab Probation and Parole Service (PP&PS) and Home Department, Government of the Punjab:

1. **Statutory Data Retention & Archival Policy**
   - *Issue*: How long should active, completed, or revoked probationer/parolee digital files, check-in photos, and GPS logs be retained before automated purging or cold-storage archiving?
   - *Status*: **Requires PP&PS legal or administrative approval**.

2. **Supervisee Smartphone Ownership & Officer-Assisted Fallback Policy**
   - *Issue*: What is the formal departmental protocol when a supervisee claims non-ownership of a smartphone, lost device, or lack of cellular data funds? What maximum travel distance or office visit frequency is required for officer-assisted check-ins?
   - *Status*: **Requires PP&PS legal or administrative approval**.

3. **Check-In Window Grace Periods & Automated Overdue Trigger Rules**
   - *Issue*: What is the permissible grace period (e.g., 2 hours, 6 hours, 24 hours) after a scheduled check-in time before the system marks a check-in as "Overdue" and alerts the officer?
   - *Status*: **Requires PP&PS legal or administrative approval**.

4. **Violation Categorization & Approval Workflow**
   - *Issue*: What specific events constitute a "Minor Violation" vs. a "Major Non-Compliance"? Does a missed check-in require immediate District Supervisory Officer sign-off, or can the Probation Officer grant a 24-hour extension?
   - *Status*: **Requires PP&PS legal or administrative approval**.

5. **NADRA CNIC Verification Integration Policy**
   - *Issue*: Will PDCSS perform live online API validation of supervisee CNIC and biometric data against NADRA databases, or rely on physical CNIC inspection during enrolment?
   - *Status*: **Requires PP&PS legal or administrative approval**.

6. **Inter-District & Inter-Divisional Case Transfer Authority**
   - *Issue*: Does transferring a supervisee's supervision jurisdiction from one district (e.g., Kasur) to another (e.g., Rawalpindi) require approval from both District Officers or Divisional/Directorate level authority?
   - *Status*: **Requires PP&PS legal or administrative approval**.

7. **Live Photograph Capture & Quality Assessment Rules**
   - *Issue*: Is live photo capture mandatory for all digital check-ins or only randomly selected check-ins? What human review process applies if a photo is dark or blurry?
   - *Status*: **Requires PP&PS legal or administrative approval**.

8. **System Administrator Data Isolation Boundary**
   - *Issue*: What administrative regulations and audit protocols govern System Administrators to prevent them from reading confidential case notes or supervisee records?
   - *Status*: **Requires PP&PS legal or administrative approval**.

9. **Data Export & Judicial Sharing Rules**
   - *Issue*: Under what legal conditions and in what formats (PDF/CSV with digital signatures) may audit logs, compliance certificates, and case files be exported for court submission?
   - *Status*: **Requires PP&PS legal or administrative approval**.

10. **Rehabilitation Referral Partner Integration Policy**
    - *Issue*: Will third-party service providers (e.g., TEVTA vocational centers, Social Welfare Department, health clinics) be granted restricted digital portal access to log attendance, or will Rehabilitation Officers handle all manual entry?
    - *Status*: **Requires PP&PS legal or administrative approval**.
