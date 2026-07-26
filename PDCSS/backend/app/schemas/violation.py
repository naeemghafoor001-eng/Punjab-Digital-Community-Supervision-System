from typing import Optional
from datetime import date, datetime
from uuid import UUID
from pydantic import BaseModel, Field

class ViolationCreate(BaseModel):
    supervisee_id: UUID
    violation_type: str = Field(..., example="UNEXCUSED_MISSED_CHECKIN")
    violation_date: date
    description: str
    supervisee_statement: Optional[str] = None

class ViolationApproval(BaseModel):
    approval_status: str = Field(..., example="APPROVED") # APPROVED, REJECTED
    approval_comments: Optional[str] = None

class ViolationResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    reporting_officer_id: UUID
    violation_type: str
    violation_date: date
    description: str
    supervisee_statement: Optional[str] = None
    supervisor_approval_status: str
    approving_supervisor_id: Optional[UUID] = None
    approval_comments: Optional[str] = None
    approval_timestamp: Optional[datetime] = None
    created_at: datetime

    class Config:
        orm_mode = True
