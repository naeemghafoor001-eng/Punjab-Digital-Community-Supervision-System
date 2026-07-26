import uuid
from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.supervisee import Supervisee
from app.schemas.supervisee import SuperviseeCreate, mask_cnic

class CRUDSupervisee:
    async def create(self, db: AsyncSession, obj_in: SuperviseeCreate) -> Supervisee:
        # Dummy encryption for local development; replace with KMS/AES-256 key in production
        cnic_enc = obj_in.cnic.encode("utf-8")
        phone_enc = (obj_in.primary_phone or "").encode("utf-8")

        db_obj = Supervisee(
            registration_number=obj_in.registration_number,
            full_name=obj_in.full_name,
            father_name=obj_in.father_name,
            cnic_masked=mask_cnic(obj_in.cnic),
            cnic_encrypted=cnic_enc,
            gender=obj_in.gender,
            date_of_birth=obj_in.date_of_birth,
            primary_phone=obj_in.primary_phone,
            residential_address=obj_in.residential_address,
            supervision_type=obj_in.supervision_type,
            device_mode=obj_in.device_mode,
            base_photo_s3_key=obj_in.base_photo_s3_key,
            primary_officer_id=obj_in.primary_officer_id,
            office_id=obj_in.office_id
        )
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def get(self, db: AsyncSession, id: uuid.UUID) -> Optional[Supervisee]:
        query = select(Supervisee).where(Supervisee.id == id)
        result = await db.execute(query)
        return result.scalar_one_or_none()

    async def get_multi_by_officer(
        self, db: AsyncSession, officer_id: uuid.UUID, skip: int = 0, limit: int = 100
    ) -> List[Supervisee]:
        query = select(Supervisee).where(Supervisee.primary_officer_id == officer_id).offset(skip).limit(limit)
        result = await db.execute(query)
        return result.scalars().all()

crud_supervisee = CRUDSupervisee()
