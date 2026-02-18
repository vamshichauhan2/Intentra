from django.urls import path
from .views import log_usage
from .access_features_views import GetFeatures

urlpatterns = [
    path("usage/", log_usage),
    path("features-summary/", GetFeatures.as_view()),
]
