from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint
from starlette.requests import Request
from starlette.responses import Response
from app.db.session import AsyncSessionLocal
from app.services.audit_service import AuditService

class AuditMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: RequestResponseEndpoint) -> Response:
        # Process the request
        response = await call_next(request)

        # Automatically log write operations (POST, PUT, DELETE, PATCH)
        if request.method in ["POST", "PUT", "DELETE", "PATCH"] and response.status_code < 400:
            client_ip = request.client.host if request.client else "127.0.0.1"
            user_agent = request.headers.get("user-agent", "Unknown")

            # Extract user context if attached by auth middleware
            user_role = getattr(request.state, "user_role", "ANONYMOUS")
            keycloak_user_id = getattr(request.state, "keycloak_user_id", None)
            user_id = getattr(request.state, "user_id", None)

            action_name = f"HTTP_{request.method}_{request.url.path.replace('/', '_').strip('_')}"
            target_entity = request.url.path.split("/")[3] if len(request.url.path.split("/")) > 3 else "general"

            try:
                async with AsyncSessionLocal() as db:
                    await AuditService.log_event(
                        db=db,
                        user_id=user_id,
                        keycloak_user_id=keycloak_user_id,
                        user_role=user_role,
                        action_name=action_name,
                        target_entity=target_entity,
                        ip_address=client_ip,
                        user_agent=user_agent
                    )
                    await db.commit()
            except Exception:
                # Middleware audit failure should not crash response, but should be logged
                pass

        return response
