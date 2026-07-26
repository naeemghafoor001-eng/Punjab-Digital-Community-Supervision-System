import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class Complaint(Base):
    __tablename__ = "complaints"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    complaint_type = Column(String(50), nullable=False)  # GRIEVANCE, SCHEDULE_CHANGE, ASSISTANCE_REQUEST
    subject = Column(String(255), nullable=False)
    description = Column(Text, nullable=False)
    status = Column(String(30), default="OPEN", nullable=False)  # OPEN, UNDER_REVIEW, RESOLVED, DISMISSED
    assigned_to_officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    officer_response = Column(Text, nullable=True)
    resolved_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="complaints")
    assigned_officer = relationship("User", backref="assigned_complaints")
