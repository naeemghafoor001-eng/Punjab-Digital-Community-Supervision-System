import unittest
from app.services.audit_service import AuditService

class TestAudit(unittest.TestCase):
    def test_audit_diff_sanitization(self):
        """Verify sensitive PII and secrets are redacted from audit diffs."""
        raw_diff = {
            "full_name": "Test Probationer",
            "cnic_encrypted": b"sensitive_bytes",
            "password": "secret_password_123",
            "supervision_type": "PROBATION"
        }
        clean = AuditService.sanitize_diff(raw_diff)
        self.assertEqual(clean["full_name"], "Test Probationer")
        self.assertEqual(clean["password"], "******[REDACTED]******")
        self.assertEqual(clean["cnic_encrypted"], "******[REDACTED]******")

if __name__ == "__main__":
    unittest.main()
