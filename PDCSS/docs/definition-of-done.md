# Punjab Digital Community Supervision System (PDCSS)
## Definition of Done (DoD)

### 1. Definition of Done Criteria Checklist

A user story, feature, or product backlog task shall be considered **Done** and eligible for release review only when all of the following quality gates have been satisfied:

#### 1. Code Quality & Standards
- [ ] Code adheres to project styling guidelines (`black` and `isort` for Python; `flutter format` and `flutter analyze` with 0 warnings for Dart).
- [ ] No secrets, hardcoded API keys, DB passwords, or certificates exist in the source code or git history.
- [ ] Environment variables are documented in `.env.example`.
- [ ] All public classes, methods, and API routes include clean inline documentation/docstrings.

#### 2. Testing & Quality Assurance
- [ ] All backend unit and integration tests pass cleanly (`pytest`).
- [ ] Automated permission tests verify all 10 user roles for new or modified endpoints with **100% authorization test pass rate**.
- [ ] IDOR checks verify that unauthorized case IDs return `403 Forbidden`.
- [ ] All Flutter widget, unit, and sync tests pass cleanly (`flutter test`).
- [ ] Offline storage, encryption, and sync retry mechanisms verified under simulated network loss.

#### 3. Privacy & Security Assurance
- [ ] Privacy Impact Assessment criteria satisfied (zero background tracking, explicit consent modal verified).
- [ ] PII data fields (CNIC, phone numbers) are masked in default serializers and UI views (`35202-******-1`).
- [ ] All database write, update, delete, view, and export events are registered in the immutable audit log table with valid HMAC hash chaining.
- [ ] System Administrator role (`ROLE_SYSTEM_ADMIN`) explicitly blocked from viewing operational case files.

#### 4. Accessibility & Localization
- [ ] UI elements translated into English and Urdu (`app_en.arb` and `app_ur.arb`).
- [ ] Right-to-Left (RTL) layout switching verified on Flutter mobile and web interfaces.
- [ ] Touch targets meet or exceed minimum dimensions of 48 x 48 dp.
- [ ] Screen reader semantics labels (TalkBack / ARIA) present on all interactive controls.
- [ ] Status indicators do not rely on color alone (combines text, icons, and shapes).

#### 5. Documentation & Review
- [ ] Database schema changes backed by clean Alembic migration scripts.
- [ ] API changes reflected in OpenAPI / FastAPI Swagger documentation.
- [ ] Code reviewed by lead architect and security specialist.
- [ ] User manual / release notes updated for PP&PS officers.
