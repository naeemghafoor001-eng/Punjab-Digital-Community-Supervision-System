import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, DateTime, Date, ForeignKey, Integer, Text, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class RNAAssessment(Base):
    __tablename__ = "rna_assessments"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    assessing_officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    assessment_date = Column(Date, nullable=False)
    risk_score_total = Column(Integer, nullable=False)
    risk_category = Column(String(20), nullable=False) # LOW, MEDIUM, HIGH
    criminogenic_needs_json = Column(JSON, nullable=False)
    recommendations = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="rna_assessments")
    assessing_officer = relationship("User", backref="conducted_rnas")
