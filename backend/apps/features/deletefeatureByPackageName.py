from rest_framework.views import APIView;
from rest_framework.permissions import IsAuthenticated;
from rest_framework import status;
from  rest_framework.response import Response;
from .models import AppUsage;

class deleteByPackageName(APIView):
    permission_classes = [IsAuthenticated]
    def delete(self,request, package_name):
        try:
            ispackageName=AppUsage.objects.get(package=package_name)
            ispackageName.delete()
            return Response(
                {"message": "Package deleted successfully"},
                status=status.HTTP_200_OK

            )
        except AppUsage.DoesNotExist:
            return Response(
                {"error": "Package Not Found"},
                 status=status.HTTP_404_NOT_FOUND
                
            )


