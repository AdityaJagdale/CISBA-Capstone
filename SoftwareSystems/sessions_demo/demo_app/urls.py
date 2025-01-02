from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('cpu_form/', views.cpu_form, name='cpu_form'),
    path('gpu_form/', views.gpu_form, name='gpu_form'),
    path('ram_form/', views.ram_form, name='ram_form'),
    path('remove_part/<str:part_type>/', views.remove_part, name='remove_part'),
    path('reset_parts/', views.reset_parts, name='reset_parts'),
]
