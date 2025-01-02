# sessions_demo_c3t

### How Django Sessions Work

* **Session Data Storage**: By default, Django stores session data in the database (django_session table).
* **Session ID Storage**: A session ID is stored in a cookie on the client-side (browser).
* **Session Management**: Django retrieves session data from the database using the session ID from the cookie, allowing persistent user data across requests.

### Session Initialization

**Session Middleware**: The session is initialized in the SessionMiddleware. This middleware is responsible for loading and saving session data for each request.

#### For example:

```python
#/settings.py

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'demo_app',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

### How It Works


1. Request Processing: When a request is received, Django processes it through the middleware. The SessionMiddleware is one of the first middlewares to handle the request.
2. Session Loading: The SessionMiddleware checks if the request has a session ID cookie. If it does, it retrieves the session data from the session store (e.g., database). If not, it initializes a new session.
3. View Handling: The view functions can now access and modify the session data using request.session.
4. Session Saving: After the view has processed the request, the SessionMiddleware saves any changes to the session data back to the session store and sets the session ID cookie if necessary.

#### For example:

```python
#.../view.py

from django.shortcuts import render, redirect

def home(request):
    # Accessing session data
    cpu = request.session.get('cpu', 'CPU not selected')
    gpu = request.session.get('gpu', 'GPU not selected')
    ram = request.session.get('ram', 'RAM not selected')

    return render(request, 'home.html', {
        'cpu': cpu,
        'gpu': gpu,
        'ram': ram,
    })
```

More infomration on the django documentation here: <https://docs.djangoproject.com/en/5.0/topics/http/sessions/>