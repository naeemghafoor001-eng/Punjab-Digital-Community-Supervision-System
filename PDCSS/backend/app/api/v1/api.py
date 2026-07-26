from fastapi import APIRouter
from app.api.v1.endpoints import (
    supervisees, documents, checkins,
    assessments, violations, audits, case_management
)

api_router = APIRouter()
api_router.include_router(supervisees.router, prefix="/supervisees", tags=["Supervisees"])
api_router.include_router(documents.router, prefix="/documents", tags=["Documents & Photos"])
api_router.include_router(checkins.router, prefix="/checkins", tags=["Digital Check-Ins"])
api_router.include_router(assessments.router, prefix="/assessments", tags=["RNA & ISRP Plans"])
api_router.include_router(violations.router, prefix="/violations", tags=["Violation Workflows"])
api_router.include_router(audits.router, prefix="/audits", tags=["Audit Ledger"])
api_router.include_router(case_management.router, prefix="/case", tags=["Case Management"])
