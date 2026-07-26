import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.violation import ViolationCreate, ViolationApproval, ViolationResponse
from app.crud.crud_violation import crud_violation
from app.api.deps import get_current_user, require_roles, CurrentUserContext

router = APIRouter()

@router.post("/", response_model=ViolationResponse, status_code=status.HTTP_201_CREATED)
async def record_violation_notice(
    violation_in: ViolationCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER"]))
):
    """Officer logs a non-compliance incident. Sets status to PENDING. No automated sanctions."""
    officer_id = uuid.uuid4()
    record = await crud_violation.create(db, violation_in, officer_id)
    return record

@router.put("/{id}/approve", response_model=ViolationResponse)
async def supervisor_approve_violation(
    id: uuid.UUID,
    approval_in: ViolationApproval,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_DISTRICT_SUPERVISOR", "ROLE_DIVISIONAL_SUPERVISOR"]))
):
    """District Supervisory Officer approves or rejects a violation report."""
    supervisor_id = uuid.uuid4()
    updated_record = await crud_violation.approve_or_reject(db, id, approval_in, supervisor_id)
    if not updated_record:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Violation record not found")
    return updated_record
