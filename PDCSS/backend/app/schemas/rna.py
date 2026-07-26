from typing import Optional, Dict, Any, List
from datetime import date, datetime
from uuid import UUID
from pydantic import BaseModel, Field

class RNACreate(BaseModel):
    supervisee_id: UUID
    assessment_date: date
    risk_score_total: int = Field(..., ge=0, le=100)
    risk_category: str = Field(..., example="MEDIUM") # LOW, MEDIUM, HIGH
    criminogenic_needs_json: Dict[str, Any]
    recommendations: Optional[str] = None

class RNAResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    assessing_officer_id: UUID
    assessment_date: date
    risk_score_total: int
    risk_category: str
    criminogenic_needs_json: Dict[str, Any]
    recommendations: Optional[str] = None
    created_at: datetime

    class Config:
        orm_mode = True

class ISRPCreate(BaseModel):
    supervisee_id: UUID
    rna_assessment_id: Optional[UUID] = None
    plan_start_date: date
    plan_target_date: date
    rehabilitation_goals_json: List[Dict[str, Any]]

class ISRPResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    rna_assessment_id: Optional[UUID] = None
    authoring_officer_id: UUID
    plan_start_date: date
    plan_target_date: date
    rehabilitation_goals_json: List[Dict[str, Any]]
    status: str
    created_at: datetime

    class Config:
        orm_mode = True
