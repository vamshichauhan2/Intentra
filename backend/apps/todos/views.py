from django.shortcuts import render

# Create your views here.
from rest_framework import status;
from rest_framework.response import Response;
from rest_framework.views import APIView;
from .models import TodosTracker;

class postTodosAPI(APIView):
    def post(self,request):


        data=request.data

        todo=TodosTracker.objects.create(
            title=data.get("title"),
            todayTarget=data.get("today_target"),
            timeNeeded=data.get("time_needed"),
            priority=data.get("priority"),

        )
        return Response(
            {"message":"created SuccessFully","id":todo.id},
            status=status.HTTP_201_CREATED,
        )