from typing import Optional, List
from datetime import datetime
from uuid import UUID
from pydantic import BaseModel, Field

class CheckInCreate(BaseModel):
    supervisee_id: UUID
    checkin_type: str = Field("SELF_MOBILE", example="SELF_MOBILE") # SELF_MOBILE, OFFICER_ASSISTED
    latitude: float = Field(..., example=31.5204)
    longitude: float = Field(..., example=74.3587)
    accuracy_meters: Optional[float] = Field(None, example=8.5)
    photo_s3_key: Optional[str] = None
    client_timestamp: datetime

class CheckInResponse(BaseModel):
    id: UUID
    supervisee_id: UUID
    checkin_timestamp: datetime
    checkin_type: str
    latitude: float
    longitude: float
    photo_s3_key: Optional[str] = None
    receipt_code: str
    receipt_signature: str
    verification_status: str
    is_synced_offline: bool

    class Config:
        orm_mode = True

class BatchSyncPayload(BaseModel):
    items: List[CheckInCreate]
