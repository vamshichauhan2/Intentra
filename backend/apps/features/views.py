import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import AppUsage
from datetime import datetime

@csrf_exempt
def usage_log(request):
    if request.method == 'POST':
        data = json.loads(request.body)

        AppUsage.objects.create(
            package=data['package'],
            intent=data['intent'],
            timestamp=datetime.fromisoformat(data['timestamp'])
        )

        return JsonResponse({"status": "saved"})
