from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.services.audit_service import AuditService
from app.api.deps import get_current_user, require_roles, CurrentUserContext

router = APIRouter()

@router.get("/verify-integrity", status_code=status.HTTP_200_OK)
async def verify_audit_chain_integrity(
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_AUDIT_OFFICER"]))
):
    """Audit Officer endpoint: verify tamper-evident HMAC hash chain continuity across audit logs."""
    is_valid = await AuditService.verify_chain_integrity(db)
    if not is_valid:
        return {
            "status": "TAMPER_DETECTED",
            "is_valid": False,
            "message": "CRITICAL: Audit log hash chain link broken or payload tampered!"
        }
    return {
        "status": "VERIFIED_INTACT",
        "is_valid": True,
        "message": "Audit ledger hash chain verified 100% intact."
    }
