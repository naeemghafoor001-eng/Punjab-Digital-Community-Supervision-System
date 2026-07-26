import io
import uuid
from typing import Tuple
from minio import Minio
from minio.error import S3Error
from app.core.config import settings

class StorageService:
    def __init__(self):
        self.client = Minio(
            settings.MINIO_ENDPOINT,
            access_key=settings.MINIO_ACCESS_KEY,
            secret_key=settings.MINIO_SECRET_KEY,
            secure=settings.MINIO_SECURE
        )
        self._ensure_bucket_exists()

    def _ensure_bucket_exists(self):
        """Create MinIO media bucket if it does not already exist."""
        try:
            if not self.client.bucket_exists(settings.MINIO_BUCKET_NAME):
                self.client.make_bucket(settings.MINIO_BUCKET_NAME)
        except Exception:
            # Handle offline or deferred initialization during tests
            pass

    def validate_file(self, content: bytes, filename: str, content_type: str, is_photo: bool = True) -> None:
        """Validate uploaded file size and MIME type to prevent malware injection."""
        max_size = 5 * 1024 * 1024 if is_photo else 10 * 1024 * 1024 # 5MB photo, 10MB doc
        if len(content) > max_size:
            raise ValueError(f"File size exceeds maximum allowed limit ({max_size // (1024*1024)} MB)")

        allowed_photo_types = {"image/jpeg", "image/png", "image/webp"}
        allowed_doc_types = {"application/pdf", "image/jpeg", "image/png"}

        allowed = allowed_photo_types if is_photo else allowed_doc_types
        if content_type not in allowed:
            raise ValueError(f"File type '{content_type}' is not authorized")

    def upload_file(self, content: bytes, content_type: str, folder_prefix: str = "checkins") -> str:
        """Upload file content to MinIO and return randomized S3 key path."""
        object_id = uuid.uuid4()
        extension = content_type.split("/")[-1]
        object_key = f"{folder_prefix}/{object_id}.{extension}"

        data_stream = io.BytesIO(content)
        self.client.put_object(
            bucket_name=settings.MINIO_BUCKET_NAME,
            object_name=object_key,
            data=data_stream,
            length=len(content),
            content_type=content_type
        )
        return object_key

storage_service = StorageService()
