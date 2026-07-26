import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, DateTime, Date, ForeignKey, Text, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class ISRPPlan(Base):
    __tablename__ = "isrp_plans"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    rna_assessment_id = Column(UUID(as_uuid=True), ForeignKey("rna_assessments.id"), nullable=True)
    authoring_officer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    plan_start_date = Column(Date, nullable=False)
    plan_target_date = Column(Date, nullable=False)
    rehabilitation_goals_json = Column(JSON, nullable=False) # List of goals, interventions, and partner referrals
    status = Column(String(30), default="IN_PROGRESS", nullable=False) # IN_PROGRESS, COMPLETED, REVISED
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="isrp_plans")
    authoring_officer = relationship("User", backref="authored_isrps")
