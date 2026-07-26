import uuid
from datetime import datetime
from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.supervision_order import SupervisionOrder
from app.models.appointment import Appointment
from app.models.complaint import Complaint
from app.models.case_transfer import CaseTransfer
from app.schemas.case_management import (
    SupervisionOrderCreate, AppointmentCreate, ComplaintCreate, CaseTransferCreate
)

class CRUDCaseManagement:
    # --- Supervision Orders ---
    async def create_order(self, db: AsyncSession, obj_in: SupervisionOrderCreate) -> SupervisionOrder:
        db_obj = SupervisionOrder(**obj_in.dict())
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def get_active_orders_by_supervisee(self, db: AsyncSession, supervisee_id: uuid.UUID) -> List[SupervisionOrder]:
        query = select(SupervisionOrder).where(
            SupervisionOrder.supervisee_id == supervisee_id,
            SupervisionOrder.is_active == True
        )
        result = await db.execute(query)
        return result.scalars().all()

    # --- Appointments ---
    async def create_appointment(self, db: AsyncSession, obj_in: AppointmentCreate, officer_id: uuid.UUID) -> Appointment:
        db_obj = Appointment(
            supervisee_id=obj_in.supervisee_id,
            officer_id=officer_id,
            appointment_type=obj_in.appointment_type,
            scheduled_datetime=obj_in.scheduled_datetime,
            location_description=obj_in.location_description,
            notes=obj_in.notes,
            status="SCHEDULED"
        )
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def get_appointments_by_supervisee(self, db: AsyncSession, supervisee_id: uuid.UUID) -> List[Appointment]:
        query = select(Appointment).where(Appointment.supervisee_id == supervisee_id).order_by(Appointment.scheduled_datetime.asc())
        result = await db.execute(query)
        return result.scalars().all()

    # --- Complaints ---
    async def create_complaint(self, db: AsyncSession, obj_in: ComplaintCreate) -> Complaint:
        db_obj = Complaint(**obj_in.dict())
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    # --- Case Transfers ---
    async def initiate_transfer(
        self, db: AsyncSession, obj_in: CaseTransferCreate,
        from_officer_id: uuid.UUID, from_office_id: uuid.UUID
    ) -> CaseTransfer:
        db_obj = CaseTransfer(
            supervisee_id=obj_in.supervisee_id,
            from_officer_id=from_officer_id,
            from_office_id=from_office_id,
            to_office_id=obj_in.to_office_id,
            reason=obj_in.reason,
            status="PENDING_ORIGIN_APPROVAL"
        )
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def endorse_transfer(self, db: AsyncSession, transfer_id: uuid.UUID, supervisor_id: uuid.UUID) -> Optional[CaseTransfer]:
        query = select(CaseTransfer).where(CaseTransfer.id == transfer_id)
        result = await db.execute(query)
        db_obj = result.scalar_one_or_none()
        if not db_obj or db_obj.status != "PENDING_ORIGIN_APPROVAL":
            return None
        db_obj.status = "ORIGIN_ENDORSED"
        db_obj.origin_supervisor_id = supervisor_id
        db_obj.origin_endorsed_at = datetime.utcnow()
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

crud_case = CRUDCaseManagement()
