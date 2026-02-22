from django.urls import path
from .views import postTodosAPI
from .get_today_todos import GetMyTodos;

urlpatterns = [
    path("create/",postTodosAPI.as_view()),#since class 
    path('tasks/',GetMyTodos.as_view()),
]
