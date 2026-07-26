import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, Date, ForeignKey, Text, LargeBinary
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from app.db.base_class import Base

class Supervisee(Base):
    __tablename__ = "supervisees"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    registration_number = Column(String(50), unique=True, nullable=False)
    full_name = Column(String(150), nullable=False)
    father_name = Column(String(150), nullable=False)
    cnic_masked = Column(String(15), nullable=False)
    cnic_encrypted = Column(LargeBinary, nullable=False)
    gender = Column(String(20), nullable=False)
    date_of_birth = Column(Date, nullable=False)
    primary_phone = Column(String(20), nullable=True)
    emergency_contact = Column(String(20), nullable=True)
    residential_address = Column(Text, nullable=False)
    home_location = Column(Geometry(geometry_type="POINT", srid=4326), nullable=True)
    supervision_type = Column(String(30), nullable=False) # PROBATION, PAROLE
    current_status = Column(String(30), default="ACTIVE", nullable=False) # ACTIVE, COMPLETED, REVOKED, TRANSFERRED, ABSCONDED
    device_mode = Column(String(30), default="SMARTPHONE_REGISTERED", nullable=False) # SMARTPHONE_REGISTERED, OFFICER_ASSISTED
    base_photo_s3_key = Column(String(255), nullable=False)
    primary_officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    office_id = Column(UUID(as_uuid=True), ForeignKey("offices.id"), nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    primary_officer = relationship("User", foreign_keys=[primary_officer_id], backref="assigned_supervisees")
    office = relationship("Office", foreign_keys=[office_id], backref="office_supervisees")
