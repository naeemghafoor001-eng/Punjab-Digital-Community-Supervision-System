import uuid
from datetime import datetime
from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from app.db.base_class import Base

class Office(Base):
    __tablename__ = "offices"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    office_name = Column(String(150), nullable=False)
    office_code = Column(String(50), unique=True, nullable=False)
    office_type = Column(String(30), nullable=False) # DIRECTORATE, DIVISION, DISTRICT, TEHSIL
    parent_office_id = Column(UUID(as_uuid=True), ForeignKey("offices.id"), nullable=True)
    district_code = Column(String(50), nullable=True)
    division_code = Column(String(50), nullable=True)
    address = Column(Text, nullable=True)
    location = Column(Geometry(geometry_type="POINT", srid=4326), nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    parent_office = relationship("Office", remote_side=[id], backref="sub_offices")
