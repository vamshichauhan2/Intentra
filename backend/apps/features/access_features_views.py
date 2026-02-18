from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Count

from .models import AppUsage


class GetFeatures(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        print("🔥 GetFeatures HIT")

        queryset = AppUsage.objects.all()
        print("COUNT:", queryset.count())

        usage_summary = (
            queryset
            .values("package")
            .annotate(total_usage=Count("id"))
            .order_by("-total_usage")
        )

        intent_summary = (
            queryset
            .values("intent")
            .annotate(total=Count("id"))
            .order_by("-total")
        )

        return Response(
            {
                "total_records": queryset.count(),
                "usage_by_package": list(usage_summary),
                "usage_by_intent": list(intent_summary),
            },
            status=status.HTTP_200_OK,
        )
