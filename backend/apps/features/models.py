from django.db import models

class AppUsage(models.Model):
    package = models.CharField(max_length=255)
    intent = models.CharField(max_length=20)
    timestamp = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)
