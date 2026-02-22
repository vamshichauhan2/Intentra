from django.db import models

# Create your models here.
class TodosTracker(models.Model):
    title=models.CharField(max_length=10000)
    todayTarget=models.BooleanField(default=True)
    timeNeeded=models.PositiveBigIntegerField(help_text="Time Needed in Minutes")
    priority=models.PositiveSmallIntegerField(default=5,help_text="1(low)->to->10(high)")
    postedTime=models.DateTimeField(auto_now_add=True) 
    def __str__(self):
        return self.title
        