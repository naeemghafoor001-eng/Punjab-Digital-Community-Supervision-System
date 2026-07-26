from typing import Optional
from datetime import date, datetime
from uuid import UUID
from pydantic import BaseModel, Field, validator

def mask_cnic(cnic: str) -> str:
    """Format CNIC as 35202-******-1 for privacy protection."""
    clean = cnic.replace("-", "").strip()
    if len(clean) == 13:
        return f"{clean[:5]}-******-{clean[-1]}"
    return cnic

class SuperviseeBase(BaseModel):
    full_name: str = Field(..., max_length=150)
    father_name: str = Field(..., max_length=150)
    cnic: str = Field(..., example="35202-1234567-1")
    gender: str = Field(..., example="MALE")
    date_of_birth: date
    primary_phone: Optional[str] = Field(None, example="03001234567")
    emergency_contact: Optional[str] = None
    residential_address: str
    supervision_type: str = Field(..., example="PROBATION") # PROBATION, PAROLE
    device_mode: str = Field("SMARTPHONE_REGISTERED", example="SMARTPHONE_REGISTERED")

    @validator("cnic")
    def validate_cnic_format(cls, v: str) -> str:
        clean = v.replace("-", "").strip()
        if not clean.isdigit() or len(clean) != 13:
            raise ValueError("CNIC must contain exactly 13 digits")
        return v

class SuperviseeCreate(SuperviseeBase):
    registration_number: str
    primary_officer_id: UUID
    office_id: UUID
    base_photo_s3_key: str

class SuperviseeResponse(BaseModel):
    id: UUID
    registration_number: str
    full_name: str
    father_name: str
    cnic_masked: str
    gender: str
    date_of_birth: date
    primary_phone: Optional[str] = None
    residential_address: str
    supervision_type: str
    current_status: str
    device_mode: str
    base_photo_s3_key: str
    primary_officer_id: UUID
    office_id: UUID
    created_at: datetime

    class Config:
        orm_mode = True
