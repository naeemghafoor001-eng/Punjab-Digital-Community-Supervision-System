import uuid
from datetime import datetime
from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.violation import ViolationRecord
from app.schemas.violation import ViolationCreate, ViolationApproval

class CRUDViolation:
    async def create(self, db: AsyncSession, obj_in: ViolationCreate, officer_id: uuid.UUID) -> ViolationRecord:
        db_obj = ViolationRecord(
            supervisee_id=obj_in.supervisee_id,
            reporting_officer_id=officer_id,
            violation_type=obj_in.violation_type,
            violation_date=obj_in.violation_date,
            description=obj_in.description,
            supervisee_statement=obj_in.supervisee_statement,
            supervisor_approval_status="PENDING"
        )
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def approve_or_reject(
        self, db: AsyncSession, violation_id: uuid.UUID, approval_in: ViolationApproval, supervisor_id: uuid.UUID
    ) -> Optional[ViolationRecord]:
        query = select(ViolationRecord).where(ViolationRecord.id == violation_id)
        result = await db.execute(query)
        db_obj = result.scalar_one_or_none()
        if not db_obj:
            return None

        db_obj.supervisor_approval_status = approval_in.approval_status
        db_obj.approving_supervisor_id = supervisor_id
        db_obj.approval_comments = approval_in.approval_comments
        db_obj.approval_timestamp = datetime.utcnow()

        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

crud_violation = CRUDViolation()
