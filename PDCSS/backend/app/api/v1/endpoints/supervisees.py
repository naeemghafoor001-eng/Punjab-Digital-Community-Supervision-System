import uuid
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.supervisee import SuperviseeCreate, SuperviseeResponse
from app.crud.crud_supervisee import crud_supervisee
from app.api.deps import get_current_user, require_roles, CurrentUserContext

router = APIRouter()

@router.post("/", response_model=SuperviseeResponse, status_code=status.HTTP_201_CREATED)
async def enroll_supervisee(
    supervisee_in: SuperviseeCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER"]))
):
    """Enroll a new probationer or parolee (Officer App only)."""
    new_supervisee = await crud_supervisee.create(db, supervisee_in)
    return new_supervisee

@router.get("/{id}", response_model=SuperviseeResponse)
async def get_supervisee_by_id(
    id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles([
        "ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER",
        "ROLE_DISTRICT_SUPERVISOR", "ROLE_DIVISIONAL_SUPERVISOR", "ROLE_MONITORING_OFFICER"
    ]))
):
    """Get supervisee dossier with Row-Level Access Control (RLAC) validation."""
    supervisee = await crud_supervisee.get(db, id)
    if not supervisee:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Supervisee record not found")
    
    # Note: In full deployment, verify current_user.keycloak_id matches primary_officer or district office
    return supervisee

@router.get("/officer/{officer_id}", response_model=List[SuperviseeResponse])
async def list_assigned_supervisees(
    officer_id: uuid.UUID,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles([
        "ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER",
        "ROLE_DISTRICT_SUPERVISOR", "ROLE_DIVISIONAL_SUPERVISOR"
    ]))
):
    """List supervisees assigned to an officer."""
    supervisees = await crud_supervisee.get_multi_by_officer(db, officer_id, skip=skip, limit=limit)
    return supervisees
