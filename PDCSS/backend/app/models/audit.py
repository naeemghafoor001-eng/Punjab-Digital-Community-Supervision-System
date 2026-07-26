import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, Text, JSON
from sqlalchemy.dialects.postgresql import UUID, INET
from app.db.base_class import Base

class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), nullable=True)
    keycloak_user_id = Column(String(100), nullable=True)
    user_role = Column(String(50), nullable=False)
    action_name = Column(String(100), nullable=False)
    target_entity = Column(String(100), nullable=False)
    target_entity_id = Column(UUID(as_uuid=True), nullable=True)
    ip_address = Column(String(50), nullable=False)
    user_agent = Column(Text, nullable=True)
    changes_diff = Column(JSON, nullable=True)
    previous_record_hash = Column(String(64), nullable=False)
    current_record_hash = Column(String(64), nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
