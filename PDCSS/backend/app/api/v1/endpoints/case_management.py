import uuid
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.case_management import (
    SupervisionOrderCreate, SupervisionOrderResponse,
    AppointmentCreate, AppointmentResponse,
    ComplaintCreate, ComplaintResponse,
    CaseTransferCreate, CaseTransferResponse
)
from app.crud.crud_case_management import crud_case
from app.api.deps import get_current_user, require_roles, CurrentUserContext

router = APIRouter()

# ------------------------------------------------------------------ Orders
@router.post("/orders/", response_model=SupervisionOrderResponse, status_code=status.HTTP_201_CREATED)
async def create_supervision_order(
    order_in: SupervisionOrderCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(
        ["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER", "ROLE_DISTRICT_SUPERVISOR"]
    ))
):
    """Record the formal court or parole board supervision order for a supervisee."""
    return await crud_case.create_order(db, order_in)

@router.get("/orders/{supervisee_id}", response_model=List[SupervisionOrderResponse])
async def list_active_orders(
    supervisee_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(
        ["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER", "ROLE_DISTRICT_SUPERVISOR",
         "ROLE_DIVISIONAL_SUPERVISOR", "ROLE_MONITORING_OFFICER"]
    ))
):
    """List active supervision orders for a supervisee."""
    return await crud_case.get_active_orders_by_supervisee(db, supervisee_id)

# ------------------------------------------------------------------ Appointments
@router.post("/appointments/", response_model=AppointmentResponse, status_code=status.HTTP_201_CREATED)
async def schedule_appointment(
    appt_in: AppointmentCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(
        ["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER", "ROLE_REHAB_OFFICER"]
    ))
):
    """Schedule an office visit, field visit, or rehabilitation session."""
    officer_id = uuid.uuid4()  # Resolved from JWT in full integration
    return await crud_case.create_appointment(db, appt_in, officer_id)

@router.get("/appointments/{supervisee_id}", response_model=List[AppointmentResponse])
async def list_supervisee_appointments(
    supervisee_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(
        ["ROLE_SUPERVISEE", "ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER",
         "ROLE_REHAB_OFFICER", "ROLE_DISTRICT_SUPERVISOR"]
    ))
):
    """List upcoming appointments for a supervisee."""
    return await crud_case.get_appointments_by_supervisee(db, supervisee_id)

# ------------------------------------------------------------------ Complaints
@router.post("/complaints/", response_model=ComplaintResponse, status_code=status.HTTP_201_CREATED)
async def submit_complaint(
    complaint_in: ComplaintCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_SUPERVISEE"]))
):
    """Supervisee submits a grievance, schedule change request, or assistance request."""
    return await crud_case.create_complaint(db, complaint_in)

# ------------------------------------------------------------------ Case Transfers
@router.post("/transfers/", response_model=CaseTransferResponse, status_code=status.HTTP_201_CREATED)
async def initiate_case_transfer(
    transfer_in: CaseTransferCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(
        ["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER"]
    ))
):
    """Officer initiates an inter-district case transfer."""
    from_officer_id = uuid.uuid4()  # Resolved from JWT in full integration
    from_office_id = uuid.uuid4()
    return await crud_case.initiate_transfer(db, transfer_in, from_officer_id, from_office_id)

@router.put("/transfers/{transfer_id}/endorse", response_model=CaseTransferResponse)
async def endorse_transfer(
    transfer_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(
        ["ROLE_DISTRICT_SUPERVISOR", "ROLE_DIVISIONAL_SUPERVISOR"]
    ))
):
    """District Supervisory Officer endorses the transfer request."""
    supervisor_id = uuid.uuid4()
    result = await crud_case.endorse_transfer(db, transfer_id, supervisor_id)
    if not result:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Transfer not found or already endorsed")
    return result
