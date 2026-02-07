from rest_framework.views import APIView;
from rest_framework.permissions import  IsAuthenticated;
from rest_framework.response import Response;

class accessUserName(APIView):
    classes_permission=[IsAuthenticated]
    def get(self,request):
        print(request.user.last_name+request.user.first_name)
        return Response(
            { 
                "name":request.user.last_name+" "+request.user.first_name,
                "email":request.user.email,

            }
        )
    