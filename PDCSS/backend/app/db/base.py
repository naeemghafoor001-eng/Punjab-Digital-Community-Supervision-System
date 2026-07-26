# Import all models here so Alembic can discover them for autogenerate
from app.db.base_class import Base  # noqa
from app.models.office import Office  # noqa
from app.models.user import User  # noqa
from app.models.supervisee import Supervisee  # noqa
from app.models.audit import AuditLog  # noqa
from app.models.checkin import DigitalCheckIn  # noqa
from app.models.rna import RNAAssessment  # noqa
from app.models.isrp import ISRPPlan  # noqa
from app.models.violation import ViolationRecord  # noqa
from app.models.supervision_order import SupervisionOrder  # noqa
from app.models.appointment import Appointment  # noqa
from app.models.complaint import Complaint  # noqa
from app.models.case_transfer import CaseTransfer  # noqa
