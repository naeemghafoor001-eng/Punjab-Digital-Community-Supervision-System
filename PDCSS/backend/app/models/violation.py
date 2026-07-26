import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, DateTime, Date, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class ViolationRecord(Base):
    __tablename__ = "violation_records"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    reporting_officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    violation_type = Column(String(50), nullable=False)
    violation_date = Column(Date, nullable=False)
    description = Column(Text, nullable=False)
    supervisee_statement = Column(Text, nullable=True)
    supervisor_approval_status = Column(String(30), default="PENDING", nullable=False) # PENDING, APPROVED, REJECTED
    approving_supervisor_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    approval_comments = Column(Text, nullable=True)
    approval_timestamp = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="violations")
    reporting_officer = relationship("User", foreign_keys=[reporting_officer_id], backref="reported_violations")
    approving_supervisor = relationship("User", foreign_keys=[approving_supervisor_id], backref="approved_violations")
