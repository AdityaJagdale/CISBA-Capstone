from django.db import models

class CPU(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class GPU(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class RAM(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name
