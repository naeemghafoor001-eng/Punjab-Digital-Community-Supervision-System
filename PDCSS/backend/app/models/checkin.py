import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, Numeric, Boolean
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from app.db.base_class import Base

class DigitalCheckIn(Base):
    __tablename__ = "digital_checkins"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    schedule_id = Column(UUID(as_uuid=True), nullable=True)
    checkin_timestamp = Column(DateTime(timezone=True), nullable=False)
    checkin_type = Column(String(30), nullable=False) # SELF_MOBILE, OFFICER_ASSISTED, OFFICE_KIOSK
    location = Column(Geometry(geometry_type="POINT", srid=4326), nullable=False)
    location_accuracy_meters = Column(Numeric(6, 2), nullable=True)
    photo_s3_key = Column(String(255), nullable=True)
    receipt_code = Column(String(64), unique=True, nullable=False)
    receipt_signature = Column(String(256), nullable=False)
    verification_status = Column(String(30), default="PENDING_REVIEW", nullable=False) # PENDING_REVIEW, VERIFIED, FLAGGED
    is_synced_offline = Column(Boolean, default=False, nullable=False)
    client_created_at = Column(DateTime(timezone=True), nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="checkins")
