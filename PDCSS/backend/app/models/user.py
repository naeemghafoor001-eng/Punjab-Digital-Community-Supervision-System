import uuid
from datetime import datetime
from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, LargeBinary
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    keycloak_user_id = Column(String(100), unique=True, nullable=False)
    cnic_masked = Column(String(15), nullable=False)
    cnic_encrypted = Column(LargeBinary, nullable=False)
    full_name = Column(String(150), nullable=False)
    email = Column(String(150), nullable=True)
    mobile_masked = Column(String(15), nullable=False)
    mobile_encrypted = Column(LargeBinary, nullable=False)
    role = Column(String(50), nullable=False)
    office_id = Column(UUID(as_uuid=True), ForeignKey("offices.id"), nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    office = relationship("Office", backref="users")
