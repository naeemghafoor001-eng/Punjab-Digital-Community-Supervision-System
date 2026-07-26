from typing import List, Optional
from pydantic_settings import BaseSettings
from pydantic import AnyHttpUrl, validator

class Settings(BaseSettings):
    PROJECT_NAME: str = "Punjab Digital Community Supervision System"
    API_V1_STR: str = "/api/v1"
    ENVIRONMENT: str = "development"
    DEBUG: bool = True

    # Security Keys
    SECRET_KEY: str = "pdcss_development_secret_key_change_in_production_32bytes"
    AUDIT_HMAC_SECRET: str = "pdcss_audit_hmac_secret_key_change_in_production_32bytes"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 15

    # Database Settings
    POSTGRES_SERVER: str = "db"
    POSTGRES_PORT: int = 5432
    POSTGRES_USER: str = "pdcss_user"
    POSTGRES_PASSWORD: str = "pdcss_secure_password_123"
    POSTGRES_DB: str = "pdcss_db"
    DATABASE_URL: Optional[str] = None

    @validator("DATABASE_URL", pre=True)
    def assemble_db_connection(cls, v: Optional[str], values: dict) -> str:
        if isinstance(v, str) and v:
            return v
        return f"postgresql+asyncpg://{values.get('POSTGRES_USER')}:{values.get('POSTGRES_PASSWORD')}@{values.get('POSTGRES_SERVER')}:{values.get('POSTGRES_PORT')}/{values.get('POSTGRES_DB')}"

    # Keycloak IAM Settings
    KEYCLOAK_SERVER_URL: str = "http://keycloak:8080"
    KEYCLOAK_REALM: str = "pdcss"
    KEYCLOAK_CLIENT_ID: str = "pdcss-backend"
    KEYCLOAK_CLIENT_SECRET: str = "pdcss-client-secret"

    # MinIO S3 Settings
    MINIO_ENDPOINT: str = "minio:9000"
    MINIO_ACCESS_KEY: str = "minio_admin"
    MINIO_SECRET_KEY: str = "minio_admin_secure_password"
    MINIO_BUCKET_NAME: str = "pdcss-media"
    MINIO_SECURE: bool = False

    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()
