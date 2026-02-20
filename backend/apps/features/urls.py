from django.urls import path
from .views import log_usage
from .access_features_views import GetFeatures
from .deletefeatureByPackageName import deleteByPackageName
urlpatterns = [
    path("usage/", log_usage),
    path("features-summary/", GetFeatures.as_view()),
    path("delete/package/<str:package_name>/",deleteByPackageName.as_view()),
]
