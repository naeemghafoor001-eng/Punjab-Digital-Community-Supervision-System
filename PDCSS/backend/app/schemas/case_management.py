from typing import Optional, List
from datetime import date, datetime
from uuid import UUID
from pydantic import BaseModel, Field

class SupervisionOrderCreate(BaseModel):
    supervisee_id: UUID
    court_or_board_name: str = Field(..., max_length=150)
    case_reference_number: str = Field(..., max_length=100)
    offense_category: str
    order_start_date: date
    order_end_date: date
    mandatory_checkin_frequency: str = Field("WEEKLY", example="WEEKLY")
    conditions_json: List[str] = Field(default_factory=list)
    order_document_s3_key: Optional[str] = None

class SupervisionOrderResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    court_or_board_name: str
    case_reference_number: str
    offense_category: str
    order_start_date: date
    order_end_date: date
    mandatory_checkin_frequency: str
    conditions_json: List[str]
    order_document_s3_key: Optional[str] = None
    is_active: bool
    created_at: datetime

    class Config:
        orm_mode = True

class AppointmentCreate(BaseModel):
    supervisee_id: UUID
    appointment_type: str = Field("OFFICE_VISIT", example="OFFICE_VISIT")
    scheduled_datetime: datetime
    location_description: Optional[str] = None
    notes: Optional[str] = None

class AppointmentResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    officer_id: UUID
    appointment_type: str
    scheduled_datetime: datetime
    location_description: Optional[str] = None
    notes: Optional[str] = None
    status: str
    created_at: datetime

    class Config:
        orm_mode = True

class ComplaintCreate(BaseModel):
    supervisee_id: UUID
    complaint_type: str = Field("GRIEVANCE", example="GRIEVANCE")
    subject: str = Field(..., max_length=255)
    description: str

class ComplaintResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    complaint_type: str
    subject: str
    description: str
    status: str
    assigned_to_officer_id: Optional[UUID] = None
    officer_response: Optional[str] = None
    created_at: datetime

    class Config:
        orm_mode = True

class CaseTransferCreate(BaseModel):
    supervisee_id: UUID
    to_office_id: UUID
    reason: str

class CaseTransferResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    from_officer_id: UUID
    from_office_id: UUID
    to_office_id: UUID
    to_officer_id: Optional[UUID] = None
    reason: str
    status: str
    created_at: datetime

    class Config:
        orm_mode = True
