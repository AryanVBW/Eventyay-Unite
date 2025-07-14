#!/bin/bash

# Development Setup Script for Eventyay Integrated System
# This script sets up both systems for local development without Docker

set -e

echo "🔧 Setting up Eventyay for Local Development..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
print_status "Checking prerequisites..."

if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed. Please install Python 3.11+"
    exit 1
fi

if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js 18+"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm"
    exit 1
fi

# Check if PostgreSQL is available
if command -v psql &> /dev/null; then
    print_status "PostgreSQL found locally"
    USE_LOCAL_POSTGRES=true
else
    print_warning "PostgreSQL not found locally. Will use SQLite for development."
    USE_LOCAL_POSTGRES=false
fi

# Setup Tickets System
print_status "Setting up Eventyay Tickets for development..."
cd eventyay-tickets

# Create virtual environment
if [ ! -d "venv" ]; then
    print_status "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment and install dependencies
print_status "Installing Python dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -e ".[dev]"

# Create development settings
print_status "Creating development settings..."
cat > src/dev_settings.py << EOF
from .settings import *
import os

# Development settings
DEBUG = True
ALLOWED_HOSTS = ['localhost', '127.0.0.1', '0.0.0.0']

# Database configuration
if os.environ.get('USE_POSTGRES', 'false').lower() == 'true':
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': 'eventyay_dev',
            'USER': 'postgres',
            'PASSWORD': 'postgres',
            'HOST': 'localhost',
            'PORT': '5432',
        }
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': os.path.join(DATA_DIR, 'db.sqlite3'),
        }
    }

# Cache configuration (use dummy cache for development)
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.dummy.DummyCache',
    }
}

# CORS settings for development
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8080",
    "http://localhost:3000",
    "http://127.0.0.1:8080",
    "http://127.0.0.1:3000",
]

CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_ALL_ORIGINS = True  # Only for development

# CSRF settings
CSRF_TRUSTED_ORIGINS = [
    'http://localhost:8080',
    'http://localhost:3000',
    'http://127.0.0.1:8080',
    'http://127.0.0.1:3000',
    'http://localhost:8000',
    'http://127.0.0.1:8000',
]

# Email backend for development
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Static files
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

# Media files
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(DATA_DIR, 'media')

# Site URL
SITE_URL = 'http://localhost:8000'

# Instance settings
INSTANCE_NAME = 'eventyay-dev'
PRETIX_REGISTRATION = True
PRETIX_PASSWORD_RESET = True

# Currency
DEFAULT_CURRENCY = 'USD'

# Logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
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
            'level': 'DEBUG',
            'propagate': False,
        },
    },
}
EOF

# Create data directory
mkdir -p data

# Run migrations
print_status "Running database migrations..."
export DJANGO_SETTINGS_MODULE=dev_settings
cd src
python manage.py migrate

# Create superuser
print_status "Creating superuser..."
python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(email='admin@eventyay.com').exists():
    User.objects.create_superuser('admin@eventyay.com', 'admin@eventyay.com', 'admin123')
    print('Superuser created: admin@eventyay.com / admin123')
else:
    print('Superuser already exists')
"

# Collect static files
print_status "Collecting static files..."
python manage.py collectstatic --noinput

cd ../..
print_success "Tickets system setup complete!"

# Setup Check-in App
print_status "Setting up Eventyay Check-in for development..."
cd eventyay-checkin

# Install dependencies
if [ ! -d "node_modules" ]; then
    print_status "Installing Node.js dependencies..."
    npm install
else
    print_status "Node.js dependencies already installed."
fi

# Update environment for local development
print_status "Configuring environment for local development..."
cat > .env.local << EOF
VITE_LOCAL_API_URL=http://localhost:8000/api/v1
VITE_TEST_API_URL=http://localhost:8000/api/v1
VITE_PROD_API_URL=http://localhost:8000/api/v1
VITE_LOCAL_PORT=8080
VITE_BASE_URL=/
EOF

cd ..
print_success "Check-in app setup complete!"

# Create development startup scripts
print_status "Creating development startup scripts..."

# Backend startup script
cat > start-backend.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Eventyay Tickets Backend..."
cd eventyay-tickets
source venv/bin/activate
export DJANGO_SETTINGS_MODULE=dev_settings
cd src
python manage.py runserver 8000
EOF

# Frontend startup script
cat > start-frontend.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Eventyay Check-in Frontend..."
cd eventyay-checkin
npm run dev
EOF

# Combined startup script
cat > start-dev.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Eventyay Development Environment..."
echo "This will start both backend and frontend in separate terminal windows."
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    osascript -e 'tell application "Terminal" to do script "cd '$(pwd)' && ./start-backend.sh"'
    sleep 2
    osascript -e 'tell application "Terminal" to do script "cd '$(pwd)' && ./start-frontend.sh"'
else
    # Linux/Unix
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal -- bash -c "./start-backend.sh; exec bash"
        sleep 2
        gnome-terminal -- bash -c "./start-frontend.sh; exec bash"
    elif command -v xterm &> /dev/null; then
        xterm -e "./start-backend.sh" &
        sleep 2
        xterm -e "./start-frontend.sh" &
    else
        echo "Please run the following commands in separate terminals:"
        echo "Terminal 1: ./start-backend.sh"
        echo "Terminal 2: ./start-frontend.sh"
    fi
fi

echo ""
echo "📋 Development URLs:"
echo "   🎫 Tickets Admin: http://localhost:8000/control/"
echo "   📱 Check-in App: http://localhost:8080/"
echo "   🔧 API: http://localhost:8000/api/v1/"
echo ""
echo "🔑 Admin Credentials:"
echo "   Email: admin@eventyay.com"
echo "   Password: admin123"
EOF

# Make scripts executable
chmod +x start-backend.sh
chmod +x start-frontend.sh
chmod +x start-dev.sh

print_success "Development environment setup complete! 🎉"

echo ""
echo "📋 Development Setup Complete!"
echo ""
echo "🚀 To start development:"
echo "   ./start-dev.sh    # Start both services"
echo "   ./start-backend.sh   # Start only backend"
echo "   ./start-frontend.sh  # Start only frontend"
echo ""
echo "📋 Access URLs:"
echo "   🎫 Tickets Admin: http://localhost:8000/control/"
echo "   📱 Check-in App: http://localhost:8080/"
echo "   🔧 API Documentation: http://localhost:8000/api/v1/"
echo ""
echo "🔑 Default Admin Credentials:"
echo "   Email: admin@eventyay.com"
echo "   Password: admin123"
echo ""
echo "🔧 Development Notes:"
echo "   - Backend uses SQLite database (data stored in eventyay-tickets/data/)"
echo "   - Frontend has hot reloading enabled"
echo "   - CORS is configured for local development"
echo "   - Check the README.md for more detailed information"
echo ""
print_success "Happy coding! 💻"