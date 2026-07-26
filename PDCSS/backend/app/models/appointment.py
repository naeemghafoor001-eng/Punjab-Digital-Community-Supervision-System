import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class Appointment(Base):
    __tablename__ = "appointments"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    appointment_type = Column(String(30), nullable=False)   # OFFICE_VISIT, FIELD_VISIT, COUNSELING, VOCATIONAL
    scheduled_datetime = Column(DateTime(timezone=True), nullable=False)
    location_description = Column(String(255), nullable=True)
    notes = Column(Text, nullable=True)
    status = Column(String(30), default="SCHEDULED", nullable=False)  # SCHEDULED, COMPLETED, MISSED, CANCELLED
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="appointments")
    officer = relationship("User", backref="scheduled_appointments")
