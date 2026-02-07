from django.urls import path


from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView ## required thing jwt token
from .views import RegisterView
from .access_view import accessUserName
#from .loginview import LoginView
urlpatterns = [
    path("register/", RegisterView.as_view()),
    #path("login/",LoginView.as_view()) 
    # JWT login (REPLACES LoginView)
    path("login/", TokenObtainPairView.as_view()),
      # Refresh access token
    path("refresh/",TokenRefreshView.as_view()),
    path("profile/",accessUserName.as_view()),
]
