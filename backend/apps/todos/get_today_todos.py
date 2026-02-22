from rest_framework.views import APIView;
from rest_framework.response import Response;
from rest_framework import status;
from rest_framework.permissions import IsAuthenticated;
from .models import TodosTracker;



class GetMyTodos(APIView):
    permission_classes = [IsAuthenticated]
    def get(self,request):
        todos=TodosTracker.objects.filter(todayTarget=True).values()
        return Response(
            #{"message":"Today's TodoList"},
             list(todos),
             status=status.HTTP_200_OK,
        )


