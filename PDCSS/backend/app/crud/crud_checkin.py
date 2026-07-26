import uuid
import random
from datetime import datetime
from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from geoalchemy2.shape import from_shape
from shapely.geometry import Point
from app.models.checkin import DigitalCheckIn
from app.schemas.checkin import CheckInCreate
from app.core.security import compute_hmac_signature

class CRUDCheckIn:
    async def create(self, db: AsyncSession, obj_in: CheckInCreate) -> DigitalCheckIn:
        # Generate receipt code and HMAC signature
        random_code = f"REC-PDCSS-{datetime.utcnow().strftime('%Y%m%d')}-{random.randint(10000, 99999)}"
        canonical_str = f"{obj_in.supervisee_id}|{obj_in.latitude}|{obj_in.longitude}|{obj_in.client_timestamp.isoformat()}|{random_code}"
        receipt_sig = compute_hmac_signature(canonical_str)

        point_geom = f"SRID=4326;POINT({obj_in.longitude} {obj_in.latitude})"

        db_obj = DigitalCheckIn(
            supervisee_id=obj_in.supervisee_id,
            checkin_timestamp=datetime.utcnow(),
            checkin_type=obj_in.checkin_type,
            location=point_geom,
            location_accuracy_meters=obj_in.accuracy_meters,
            photo_s3_key=obj_in.photo_s3_key,
            receipt_code=random_code,
            receipt_signature=receipt_sig,
            verification_status="PENDING_REVIEW",
            is_synced_offline=False,
            client_created_at=obj_in.client_timestamp
        )

        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def get_multi_by_supervisee(
        self, db: AsyncSession, supervisee_id: uuid.UUID, skip: int = 0, limit: int = 100
    ) -> List[DigitalCheckIn]:
        query = select(DigitalCheckIn).where(DigitalCheckIn.supervisee_id == supervisee_id).order_by(DigitalCheckIn.checkin_timestamp.desc()).offset(skip).limit(limit)
        result = await db.execute(query)
        return result.scalars().all()

crud_checkin = CRUDCheckIn()
