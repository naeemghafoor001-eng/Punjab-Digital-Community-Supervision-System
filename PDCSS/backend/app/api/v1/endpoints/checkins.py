import uuid
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.checkin import CheckInCreate, CheckInResponse, BatchSyncPayload
from app.crud.crud_checkin import crud_checkin
from app.api.deps import get_current_user, require_roles, CurrentUserContext

router = APIRouter()

@router.post("/", status_code=status.HTTP_201_CREATED)
async def submit_checkin(
    checkin_in: CheckInCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_SUPERVISEE", "ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER"]))
):
    """Submit a single digital check-in with location snapshot."""
    checkin = await crud_checkin.create(db, checkin_in)
    return {
        "checkin_id": checkin.id,
        "receipt_code": checkin.receipt_code,
        "receipt_signature": checkin.receipt_signature,
        "verification_status": checkin.verification_status,
        "server_timestamp": checkin.checkin_timestamp
    }

@router.post("/batch", status_code=status.HTTP_200_OK)
async def sync_checkin_batch(
    payload: BatchSyncPayload,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(get_current_user)
):
    """Process a batch of queued offline check-ins submitted by mobile sync manager."""
    processed_receipts = []
    for item in payload.items:
        checkin = await crud_checkin.create(db, item)
        processed_receipts.append({
            "supervisee_id": item.supervisee_id,
            "receipt_code": checkin.receipt_code,
            "status": "SYNCED"
        })
    return {"synced_count": len(processed_receipts), "items": processed_receipts}
