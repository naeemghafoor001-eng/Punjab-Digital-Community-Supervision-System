import unittest
from app.core.security import create_access_token, get_password_hash, verify_password
from app.api.deps import CurrentUserContext, require_roles
from fastapi import HTTPException

class TestPermissions(unittest.TestCase):
    def test_argon2_password_hashing(self):
        """Verify Argon2id password hashing and verification."""
        password = "SuperSecurePassword123!"
        hashed = get_password_hash(password)
        self.assertTrue(hashed.startswith("$argon2id$"))
        self.assertTrue(verify_password(password, hashed))
        self.assertFalse(verify_password("WrongPassword", hashed))

    def test_system_admin_isolation(self):
        """Verify System Administrator is strictly isolated from operational endpoints."""
        role_checker = require_roles(["ROLE_PROBATION_OFFICER"])
        admin_context = CurrentUserContext(keycloak_id="admin-uuid", role="ROLE_SYSTEM_ADMIN")
        
        with self.assertRaises(HTTPException) as cm:
            role_checker(admin_context)
        
        self.assertEqual(cm.exception.status_code, 403)
        self.assertIn("System Administrators are isolated", cm.exception.detail)

    def test_authorized_officer_access(self):
        """Verify Probation Officer passes role validation check."""
        role_checker = require_roles(["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER"])
        officer_context = CurrentUserContext(keycloak_id="officer-uuid", role="ROLE_PROBATION_OFFICER")
        
        validated_context = role_checker(officer_context)
        self.assertEqual(validated_context.role, "ROLE_PROBATION_OFFICER")

if __name__ == "__main__":
    unittest.main()
