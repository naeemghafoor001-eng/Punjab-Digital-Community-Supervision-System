from typing import Generator, Optional, List
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.core.security import decode_access_token
from app.models.user import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

class CurrentUserContext:
    def __init__(self, keycloak_id: str, role: str, email: Optional[str] = None):
        self.keycloak_id = keycloak_id
        self.role = role
        self.email = email

async def get_current_user(token: str = Depends(oauth2_scheme)) -> CurrentUserContext:
    """Validate Bearer token and return active user security context."""
    try:
        payload = decode_access_token(token)
        keycloak_id: str = payload.get("sub")
        role: str = payload.get("role", "ROLE_SUPERVISEE")
        if not keycloak_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token payload",
                headers={"WWW-Authenticate": "Bearer"},
            )
        return CurrentUserContext(keycloak_id=keycloak_id, role=role)
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

def require_roles(allowed_roles: List[str]):
    """Role-Based Access Control (RBAC) dependency validator."""
    def role_checker(current_user: CurrentUserContext = Depends(get_current_user)):
        if current_user.role in allowed_roles:
            return current_user
        # Isolation: System admin blocked from operational case endpoints
        if current_user.role == "ROLE_SYSTEM_ADMIN":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="System Administrators are isolated from operational case data."
            )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Role '{current_user.role}' is not authorized to access this resource."
        )
    return role_checker
