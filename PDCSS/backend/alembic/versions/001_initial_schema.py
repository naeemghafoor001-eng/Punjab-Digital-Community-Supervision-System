"""Initial PDCSS schema migration

Revision ID: 001_initial_schema
Revises: 
Create Date: 2026-07-25
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID, INET
from geoalchemy2 import Geometry

revision = '001_initial_schema'
down_revision = None
branch_labels = None
depends_on = None

def upgrade() -> None:
    # Offices hierarchy
    op.create_table(
        'offices',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('office_name', sa.String(150), nullable=False),
        sa.Column('office_code', sa.String(50), unique=True, nullable=False),
        sa.Column('office_type', sa.String(30), nullable=False),
        sa.Column('parent_office_id', UUID(as_uuid=True), sa.ForeignKey('offices.id'), nullable=True),
        sa.Column('district_code', sa.String(50), nullable=True),
        sa.Column('division_code', sa.String(50), nullable=True),
        sa.Column('address', sa.Text, nullable=True),
        sa.Column('location', Geometry(geometry_type='POINT', srid=4326), nullable=True),
        sa.Column('is_active', sa.Boolean, default=True, nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index('idx_offices_parent', 'offices', ['parent_office_id'])
    op.create_index('idx_offices_spatial', 'offices', ['location'], postgresql_using='gist')

    # Users
    op.create_table(
        'users',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('keycloak_user_id', sa.String(100), unique=True, nullable=False),
        sa.Column('cnic_masked', sa.String(15), nullable=False),
        sa.Column('cnic_encrypted', sa.LargeBinary, nullable=False),
        sa.Column('full_name', sa.String(150), nullable=False),
        sa.Column('email', sa.String(150), nullable=True),
        sa.Column('mobile_masked', sa.String(15), nullable=False),
        sa.Column('mobile_encrypted', sa.LargeBinary, nullable=False),
        sa.Column('role', sa.String(50), nullable=False),
        sa.Column('office_id', UUID(as_uuid=True), sa.ForeignKey('offices.id'), nullable=False),
        sa.Column('is_active', sa.Boolean, default=True, nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index('idx_users_office', 'users', ['office_id'])
    op.create_index('idx_users_role', 'users', ['role'])

    # Supervisees
    op.create_table(
        'supervisees',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('registration_number', sa.String(50), unique=True, nullable=False),
        sa.Column('full_name', sa.String(150), nullable=False),
        sa.Column('father_name', sa.String(150), nullable=False),
        sa.Column('cnic_masked', sa.String(15), nullable=False),
        sa.Column('cnic_encrypted', sa.LargeBinary, nullable=False),
        sa.Column('gender', sa.String(20), nullable=False),
        sa.Column('date_of_birth', sa.Date, nullable=False),
        sa.Column('primary_phone', sa.String(20), nullable=True),
        sa.Column('emergency_contact', sa.String(20), nullable=True),
        sa.Column('residential_address', sa.Text, nullable=False),
        sa.Column('home_location', Geometry(geometry_type='POINT', srid=4326), nullable=True),
        sa.Column('supervision_type', sa.String(30), nullable=False),
        sa.Column('current_status', sa.String(30), nullable=False, server_default='ACTIVE'),
        sa.Column('device_mode', sa.String(30), nullable=False, server_default='SMARTPHONE_REGISTERED'),
        sa.Column('base_photo_s3_key', sa.String(255), nullable=False),
        sa.Column('primary_officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('office_id', UUID(as_uuid=True), sa.ForeignKey('offices.id'), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index('idx_supervisees_officer', 'supervisees', ['primary_officer_id'])
    op.create_index('idx_supervisees_status', 'supervisees', ['current_status'])

    # Supervision Orders
    op.create_table(
        'supervision_orders',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('court_or_board_name', sa.String(150), nullable=False),
        sa.Column('case_reference_number', sa.String(100), nullable=False),
        sa.Column('offense_category', sa.String(150), nullable=False),
        sa.Column('order_start_date', sa.Date, nullable=False),
        sa.Column('order_end_date', sa.Date, nullable=False),
        sa.Column('mandatory_checkin_frequency', sa.String(30), nullable=False),
        sa.Column('conditions_json', sa.JSON, nullable=False),
        sa.Column('order_document_s3_key', sa.String(255), nullable=True),
        sa.Column('is_active', sa.Boolean, nullable=False, server_default='true'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )

    # Appointments
    op.create_table(
        'appointments',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('appointment_type', sa.String(30), nullable=False),
        sa.Column('scheduled_datetime', sa.DateTime(timezone=True), nullable=False),
        sa.Column('location_description', sa.String(255), nullable=True),
        sa.Column('notes', sa.Text, nullable=True),
        sa.Column('status', sa.String(30), nullable=False, server_default='SCHEDULED'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )

    # Digital Check-ins
    op.create_table(
        'digital_checkins',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('schedule_id', UUID(as_uuid=True), nullable=True),
        sa.Column('checkin_timestamp', sa.DateTime(timezone=True), nullable=False),
        sa.Column('checkin_type', sa.String(30), nullable=False),
        sa.Column('location', Geometry(geometry_type='POINT', srid=4326), nullable=False),
        sa.Column('location_accuracy_meters', sa.Numeric(6, 2), nullable=True),
        sa.Column('photo_s3_key', sa.String(255), nullable=True),
        sa.Column('receipt_code', sa.String(64), unique=True, nullable=False),
        sa.Column('receipt_signature', sa.String(256), nullable=False),
        sa.Column('verification_status', sa.String(30), nullable=False, server_default='PENDING_REVIEW'),
        sa.Column('is_synced_offline', sa.Boolean, nullable=False, server_default='false'),
        sa.Column('client_created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index('idx_checkins_supervisee', 'digital_checkins', ['supervisee_id'])
    op.create_index('idx_checkins_spatial', 'digital_checkins', ['location'], postgresql_using='gist')

    # RNA Assessments
    op.create_table(
        'rna_assessments',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('assessing_officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('assessment_date', sa.Date, nullable=False),
        sa.Column('risk_score_total', sa.Integer, nullable=False),
        sa.Column('risk_category', sa.String(20), nullable=False),
        sa.Column('criminogenic_needs_json', sa.JSON, nullable=False),
        sa.Column('recommendations', sa.Text, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )

    # ISRP Plans
    op.create_table(
        'isrp_plans',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('rna_assessment_id', UUID(as_uuid=True), sa.ForeignKey('rna_assessments.id'), nullable=True),
        sa.Column('authoring_officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('plan_start_date', sa.Date, nullable=False),
        sa.Column('plan_target_date', sa.Date, nullable=False),
        sa.Column('rehabilitation_goals_json', sa.JSON, nullable=False),
        sa.Column('status', sa.String(30), nullable=False, server_default='IN_PROGRESS'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )

    # Violation Records
    op.create_table(
        'violation_records',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('reporting_officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('violation_type', sa.String(50), nullable=False),
        sa.Column('violation_date', sa.Date, nullable=False),
        sa.Column('description', sa.Text, nullable=False),
        sa.Column('supervisee_statement', sa.Text, nullable=True),
        sa.Column('supervisor_approval_status', sa.String(30), nullable=False, server_default='PENDING'),
        sa.Column('approving_supervisor_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=True),
        sa.Column('approval_comments', sa.Text, nullable=True),
        sa.Column('approval_timestamp', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )

    # Complaints
    op.create_table(
        'complaints',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('complaint_type', sa.String(50), nullable=False),
        sa.Column('subject', sa.String(255), nullable=False),
        sa.Column('description', sa.Text, nullable=False),
        sa.Column('status', sa.String(30), nullable=False, server_default='OPEN'),
        sa.Column('assigned_to_officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=True),
        sa.Column('officer_response', sa.Text, nullable=True),
        sa.Column('resolved_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )

    # Case Transfers
    op.create_table(
        'case_transfers',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('supervisee_id', UUID(as_uuid=True), sa.ForeignKey('supervisees.id'), nullable=False),
        sa.Column('from_officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('from_office_id', UUID(as_uuid=True), sa.ForeignKey('offices.id'), nullable=False),
        sa.Column('to_office_id', UUID(as_uuid=True), sa.ForeignKey('offices.id'), nullable=False),
        sa.Column('to_officer_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=True),
        sa.Column('reason', sa.Text, nullable=False),
        sa.Column('status', sa.String(30), nullable=False, server_default='PENDING_ORIGIN_APPROVAL'),
        sa.Column('origin_supervisor_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=True),
        sa.Column('origin_endorsed_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('receiving_supervisor_id', UUID(as_uuid=True), sa.ForeignKey('users.id'), nullable=True),
        sa.Column('receiving_approved_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('completed_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )

    # Audit Logs
    op.create_table(
        'audit_logs',
        sa.Column('id', UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column('user_id', UUID(as_uuid=True), nullable=True),
        sa.Column('keycloak_user_id', sa.String(100), nullable=True),
        sa.Column('user_role', sa.String(50), nullable=False),
        sa.Column('action_name', sa.String(100), nullable=False),
        sa.Column('target_entity', sa.String(100), nullable=False),
        sa.Column('target_entity_id', UUID(as_uuid=True), nullable=True),
        sa.Column('ip_address', sa.String(50), nullable=False),
        sa.Column('user_agent', sa.Text, nullable=True),
        sa.Column('changes_diff', sa.JSON, nullable=True),
        sa.Column('previous_record_hash', sa.String(64), nullable=False),
        sa.Column('current_record_hash', sa.String(64), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index('idx_audit_user', 'audit_logs', ['user_id'])
    op.create_index('idx_audit_action', 'audit_logs', ['action_name'])
    op.create_index('idx_audit_target', 'audit_logs', ['target_entity', 'target_entity_id'])


def downgrade() -> None:
    op.drop_table('audit_logs')
    op.drop_table('case_transfers')
    op.drop_table('complaints')
    op.drop_table('violation_records')
    op.drop_table('isrp_plans')
    op.drop_table('rna_assessments')
    op.drop_table('digital_checkins')
    op.drop_table('appointments')
    op.drop_table('supervision_orders')
    op.drop_table('supervisees')
    op.drop_table('users')
    op.drop_table('offices')
