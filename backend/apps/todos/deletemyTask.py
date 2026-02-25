from rest_framework.views import APIView;
from rest_framework.response import Response;
from rest_framework import status;
from .models import TodosTracker;


class DeleteMyTodo(APIView):
    def delete(self,request,package_name):
        try:
            Task=TodosTracker.objects.get(id=package_name)
            Task.delete()
            return Response(
                status=status.HTTP_200_OK
            )
        except TodosTracker.DoesNotExist:
            return Response(
                status=status.HTTP_204_NO_CONTENT
            )



