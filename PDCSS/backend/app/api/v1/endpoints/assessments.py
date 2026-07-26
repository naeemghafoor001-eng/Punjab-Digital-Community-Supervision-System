import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.rna import RNACreate, RNAResponse, ISRPCreate, ISRPResponse
from app.crud.crud_assessment import crud_assessment
from app.api.deps import get_current_user, require_roles, CurrentUserContext

router = APIRouter()

@router.post("/rna", response_model=RNAResponse, status_code=status.HTTP_201_CREATED)
async def create_rna_assessment(
    rna_in: RNACreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER", "ROLE_REHAB_OFFICER"]))
):
    """Record a Risk and Needs Assessment (RNA)."""
    # Dummy UUID mapping for development officer ID
    officer_id = uuid.uuid4()
    assessment = await crud_assessment.create_rna(db, rna_in, officer_id)
    return assessment

@router.post("/isrp", response_model=ISRPResponse, status_code=status.HTTP_201_CREATED)
async def create_isrp_plan(
    isrp_in: ISRPCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserContext = Depends(require_roles(["ROLE_PROBATION_OFFICER", "ROLE_PAROLE_OFFICER", "ROLE_REHAB_OFFICER"]))
):
    """Create an Individual Supervision and Rehabilitation Plan (ISRP)."""
    officer_id = uuid.uuid4()
    plan = await crud_assessment.create_isrp(db, isrp_in, officer_id)
    return plan
