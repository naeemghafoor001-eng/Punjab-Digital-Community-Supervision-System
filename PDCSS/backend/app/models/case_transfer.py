import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class CaseTransfer(Base):
    __tablename__ = "case_transfers"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    from_officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    from_office_id = Column(UUID(as_uuid=True), ForeignKey("offices.id"), nullable=False)
    to_office_id = Column(UUID(as_uuid=True), ForeignKey("offices.id"), nullable=False)
    to_officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)  # assigned after receiving acceptance
    reason = Column(Text, nullable=False)
    status = Column(String(30), default="PENDING_ORIGIN_APPROVAL", nullable=False)
    # PENDING_ORIGIN_APPROVAL, ORIGIN_ENDORSED, PENDING_RECEIVING_APPROVAL, COMPLETED, REJECTED
    origin_supervisor_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    origin_endorsed_at = Column(DateTime(timezone=True), nullable=True)
    receiving_supervisor_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    receiving_approved_at = Column(DateTime(timezone=True), nullable=True)
    completed_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="case_transfers")
    from_officer = relationship("User", foreign_keys=[from_officer_id])
    to_officer = relationship("User", foreign_keys=[to_officer_id])
    from_office = relationship("Office", foreign_keys=[from_office_id])
    to_office = relationship("Office", foreign_keys=[to_office_id])
