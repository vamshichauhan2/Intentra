from django.urls import path
from .views import postTodosAPI
from .get_today_todos import GetMyTodos;
from .deletemyTask import DeleteMyTodo;

urlpatterns = [
    path("create/",postTodosAPI.as_view()),#since class 
    path('tasks/',GetMyTodos.as_view()),
    path('task/delete/<str:package_name>/' ,DeleteMyTodo.as_view()),
]
