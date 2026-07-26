import uuid
from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.rna import RNAAssessment
from app.models.isrp import ISRPPlan
from app.schemas.rna import RNACreate, ISRPCreate

class CRUDAssessment:
    async def create_rna(self, db: AsyncSession, obj_in: RNACreate, officer_id: uuid.UUID) -> RNAAssessment:
        db_obj = RNAAssessment(
            supervisee_id=obj_in.supervisee_id,
            assessing_officer_id=officer_id,
            assessment_date=obj_in.assessment_date,
            risk_score_total=obj_in.risk_score_total,
            risk_category=obj_in.risk_category,
            criminogenic_needs_json=obj_in.criminogenic_needs_json,
            recommendations=obj_in.recommendations
        )
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def create_isrp(self, db: AsyncSession, obj_in: ISRPCreate, officer_id: uuid.UUID) -> ISRPPlan:
        db_obj = ISRPPlan(
            supervisee_id=obj_in.supervisee_id,
            rna_assessment_id=obj_in.rna_assessment_id,
            authoring_officer_id=officer_id,
            plan_start_date=obj_in.plan_start_date,
            plan_target_date=obj_in.plan_target_date,
            rehabilitation_goals_json=obj_in.rehabilitation_goals_json,
            status="IN_PROGRESS"
        )
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

crud_assessment = CRUDAssessment()
