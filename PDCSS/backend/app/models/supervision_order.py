import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, DateTime, Date, ForeignKey, Boolean, JSON, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class SupervisionOrder(Base):
    __tablename__ = "supervision_orders"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    supervisee_id = Column(UUID(as_uuid=True), ForeignKey("supervisees.id"), nullable=False)
    court_or_board_name = Column(String(150), nullable=False)
    case_reference_number = Column(String(100), nullable=False)
    offense_category = Column(String(150), nullable=False)
    order_start_date = Column(Date, nullable=False)
    order_end_date = Column(Date, nullable=False)
    mandatory_checkin_frequency = Column(String(30), nullable=False)  # DAILY, WEEKLY, BIWEEKLY, MONTHLY
    conditions_json = Column(JSON, nullable=False, default=list)
    order_document_s3_key = Column(String(255), nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    supervisee = relationship("Supervisee", backref="supervision_orders")
