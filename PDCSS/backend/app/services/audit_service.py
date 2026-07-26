import json
import uuid
from typing import Optional, Dict, Any
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc
from app.models.audit import AuditLog
from app.core.security import compute_hmac_signature

class AuditService:
    @staticmethod
    async def get_latest_hash(db: AsyncSession) -> str:
        """Fetch the current record hash of the most recent audit entry."""
        query = select(AuditLog.current_record_hash).order_by(desc(AuditLog.created_at)).limit(1)
        result = await db.execute(query)
        latest_hash = result.scalar_one_or_none()
        return latest_hash or "0000000000000000000000000000000000000000000000000000000000000000"

    @staticmethod
    def sanitize_diff(diff: Optional[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
        """Mask sensitive PII fields in diff before writing to audit log."""
        if not diff:
            return None
        sanitized = json.loads(json.dumps(diff, default=str))
        sensitive_keys = {"password", "secret", "cnic_encrypted", "mobile_encrypted", "access_token", "refresh_token"}
        for k in list(sanitized.keys()):
            if any(s in k.lower() for s in sensitive_keys):
                sanitized[k] = "******[REDACTED]******"
        return sanitized

    @classmethod
    async def log_event(
        cls,
        db: AsyncSession,
        user_role: str,
        action_name: str,
        target_entity: str,
        ip_address: str,
        user_id: Optional[uuid.UUID] = None,
        keycloak_user_id: Optional[str] = None,
        target_entity_id: Optional[uuid.UUID] = None,
        user_agent: Optional[str] = None,
        changes_diff: Optional[Dict[str, Any]] = None,
    ) -> AuditLog:
        """Create an append-only audit record chained to the previous record's cryptographic hash."""
        prev_hash = await cls.get_latest_hash(db)
        clean_diff = cls.sanitize_diff(changes_diff)
        diff_str = json.dumps(clean_diff, sort_keys=True) if clean_diff else ""

        # Construct canonical string representation for HMAC computation
        payload_canonical = f"{user_id or ''}|{keycloak_user_id or ''}|{user_role}|{action_name}|{target_entity}|{target_entity_id or ''}|{ip_address}|{diff_str}|{prev_hash}"
        curr_hash = compute_hmac_signature(payload_canonical)

        audit_entry = AuditLog(
            user_id=user_id,
            keycloak_user_id=keycloak_user_id,
            user_role=user_role,
            action_name=action_name,
            target_entity=target_entity,
            target_entity_id=target_entity_id,
            ip_address=ip_address,
            user_agent=user_agent,
            changes_diff=clean_diff,
            previous_record_hash=prev_hash,
            current_record_hash=curr_hash
        )

        db.add(audit_entry)
        await db.flush()
        return audit_entry

    @classmethod
    async def verify_chain_integrity(cls, db: AsyncSession, limit: int = 1000) -> bool:
        """Audit Officer routine: verify cryptographic continuity of the audit ledger."""
        query = select(AuditLog).order_by(AuditLog.created_at.asc()).limit(limit)
        result = await db.execute(query)
        records = result.scalars().all()

        expected_prev_hash = "0000000000000000000000000000000000000000000000000000000000000000"
        for record in records:
            if record.previous_record_hash != expected_prev_hash:
                return False  # Chain link broken

            diff_str = json.dumps(record.changes_diff, sort_keys=True) if record.changes_diff else ""
            payload_canonical = f"{record.user_id or ''}|{record.keycloak_user_id or ''}|{record.user_role}|{record.action_name}|{record.target_entity}|{record.target_entity_id or ''}|{record.ip_address}|{diff_str}|{record.previous_record_hash}"
            recomputed_hash = compute_hmac_signature(payload_canonical)

            if recomputed_hash != record.current_record_hash:
                return False  # Record payload tampered

            expected_prev_hash = record.current_record_hash

        return True
