import os
from urllib.parse import urlparse

from .settings import *

# Database configuration
if 'DATABASE_URL' in os.environ:
    import dj_database_url
    DATABASES = {
        'default': dj_database_url.parse(os.environ['DATABASE_URL'])
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': os.environ.get('POSTGRES_DB', 'eventyay'),
            'USER': os.environ.get('POSTGRES_USER', 'eventyay'),
            'PASSWORD': os.environ.get('POSTGRES_PASSWORD', 'eventyay'),
            'HOST': os.environ.get('POSTGRES_HOST', 'postgres'),
            'PORT': os.environ.get('POSTGRES_PORT', '5432'),
        }
    }

# Redis configuration
REDIS_URL = os.environ.get('REDIS_URL', 'redis://redis:6379/0')
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': REDIS_URL,
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
        }
    }
}

# Session configuration
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
SESSION_CACHE_ALIAS = 'default'

# Celery configuration
CELERY_BROKER_URL = REDIS_URL
CELERY_RESULT_BACKEND = REDIS_URL

# Security settings
DEBUG = os.environ.get('DEBUG', 'False').lower() == 'true'
ALLOWED_HOSTS = ['*']  # Configure appropriately for production

# Site URL
SITE_URL = os.environ.get('PRETIX_URL', 'http://localhost:8000')
if SITE_URL.endswith('/'):
    SITE_URL = SITE_URL[:-1]

# CORS settings for API access from check-in app
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8080",
    "http://localhost:3000",
    "http://127.0.0.1:8080",
    "http://127.0.0.1:3000",
]

CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_ALL_ORIGINS = DEBUG  # Only in development

# API settings
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework.authentication.SessionAuthentication',
        'pretix.api.auth.DeviceTokenAuthentication',
        'pretix.api.auth.TeamTokenAuthentication',
        'oauth2_provider.contrib.rest_framework.OAuth2Authentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated',
    ],
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 50,
    'DEFAULT_VERSIONING_CLASS': 'rest_framework.versioning.NamespaceVersioning',
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
    ],
}

# Static and media files
STATIC_URL = '/static/'
STATIC_ROOT = '/static'
MEDIA_URL = '/media/'
MEDIA_ROOT = '/data/media'

# Data directory
DATA_DIR = os.environ.get('PRETIX_DATADIR', '/data')

# Logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': False,
        },
        'pretix': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': False,
        },
    },
}

# Email configuration (configure as needed)
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Instance configuration
INSTANCE_NAME = os.environ.get('PRETIX_INSTANCE_NAME', 'eventyay')
PRETIX_REGISTRATION = True
PRETIX_PASSWORD_RESET = True

# Currency
DEFAULT_CURRENCY = os.environ.get('PRETIX_CURRENCY', 'USD')

# Trust proxy headers
if os.environ.get('PRETIX_TRUST_X_FORWARDED_FOR', 'off').lower() in ('on', 'true', '1'):
    USE_X_FORWARDED_HOST = True
    USE_X_FORWARDED_PORT = True

if os.environ.get('PRETIX_TRUST_X_FORWARDED_PROTO', 'off').lower() in ('on', 'true', '1'):
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# CSRF settings
CSRF_TRUSTED_ORIGINS = [
    'http://localhost:8080',
    'http://localhost:3000',
    'http://127.0.0.1:8080',
    'http://127.0.0.1:3000',
]

if SITE_URL:
    parsed = urlparse(SITE_URL)
    CSRF_TRUSTED_ORIGINS.append(f"{parsed.scheme}://{parsed.netloc}")