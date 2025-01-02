from django import forms
from .models import CPU, GPU, RAM

class CPUForm(forms.Form):
    custom_cpu = forms.CharField(label='Or enter a custom CPU', max_length=100, required=False)

class GPUForm(forms.Form):
    custom_gpu = forms.CharField(label='Or enter a custom GPU', max_length=100, required=False)

class RAMForm(forms.Form):
    custom_ram = forms.CharField(label='Or enter a custom RAM', max_length=100, required=False)
