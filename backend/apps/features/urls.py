from django.urls import path
from .views import log_usage

urlpatterns = [
    path("usage/", log_usage),
]
