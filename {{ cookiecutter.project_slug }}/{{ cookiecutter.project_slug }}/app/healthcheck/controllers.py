from fastapi import APIRouter

router = APIRouter()


@router.get(
    "/healthz",
    status_code=204,
)
async def get_healthcheck():
    return
