from django.shortcuts import render, redirect
from .forms import CPUForm, GPUForm, RAMForm
from .models import CPU, GPU, RAM

def home(request):
    cpu = request.session.get('cpu', 'CPU not selected')
    gpu = request.session.get('gpu', 'GPU not selected')
    ram = request.session.get('ram', 'RAM not selected')

    return render(request, 'home.html', {
        'cpu': cpu,
        'gpu': gpu,
        'ram': ram,
    })

def cpu_form(request):
    cpus = CPU.objects.all()
    if request.method == 'POST':
        form = CPUForm(request.POST)
        if form.is_valid():
            custom_cpu = form.cleaned_data['custom_cpu']
            cpu_name = request.POST.get('cpu', '')
            if custom_cpu:
                cpu, created = CPU.objects.get_or_create(name=custom_cpu)
                request.session['cpu'] = cpu.name
            elif cpu_name:
                request.session['cpu'] = cpu_name
            return redirect('home')
    else:
        form = CPUForm()

    return render(request, 'cpu_form.html', {'form': form, 'cpus': cpus})

def gpu_form(request):
    gpus = GPU.objects.all()
    if request.method == 'POST':
        form = GPUForm(request.POST)
        if form.is_valid():
            custom_gpu = form.cleaned_data['custom_gpu']
            gpu_name = request.POST.get('gpu', '')
            if custom_gpu:
                gpu, created = GPU.objects.get_or_create(name=custom_gpu)
                request.session['gpu'] = gpu.name
            elif gpu_name:
                request.session['gpu'] = gpu_name
            return redirect('home')
    else:
        form = GPUForm()

    return render(request, 'gpu_form.html', {'form': form, 'gpus': gpus})

def ram_form(request):
    rams = RAM.objects.all()
    if request.method == 'POST':
        form = RAMForm(request.POST)
        if form.is_valid():
            custom_ram = form.cleaned_data['custom_ram']
            ram_name = request.POST.get('ram', '')
            if custom_ram:
                ram, created = RAM.objects.get_or_create(name=custom_ram)
                request.session['ram'] = ram.name
            elif ram_name:
                request.session['ram'] = ram_name
            return redirect('home')
    else:
        form = RAMForm()

    return render(request, 'ram_form.html', {'form': form, 'rams': rams})

def remove_part(request, part_type):
    if part_type in request.session:
        del request.session[part_type]
    return redirect('home')

def reset_parts(request):
    # Clear all parts from the session
    request.session.pop('cpu', None)
    request.session.pop('gpu', None)
    request.session.pop('ram', None)
    return redirect('home')