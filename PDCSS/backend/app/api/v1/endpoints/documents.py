from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status
from app.services.storage_service import storage_service
from app.api.deps import get_current_user, CurrentUserContext

router = APIRouter()

@router.post("/upload", status_code=status.HTTP_201_CREATED)
async def upload_document_or_photo(
    file: UploadFile = File(...),
    folder_prefix: str = "general",
    current_user: CurrentUserContext = Depends(get_current_user)
):
    """Upload photo or document to MinIO with MIME validation and magic byte check."""
    try:
        content = await file.read()
        is_photo = folder_prefix in ["photos", "base_photos", "checkins"]
        storage_service.validate_file(content, file.filename, file.content_type, is_photo=is_photo)
        s3_key = storage_service.upload_file(content, file.content_type, folder_prefix=folder_prefix)
        return {
            "filename": file.filename,
            "content_type": file.content_type,
            "s3_key": s3_key,
            "size_bytes": len(content)
        }
    except ValueError as ve:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(ve))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to upload file to storage")
