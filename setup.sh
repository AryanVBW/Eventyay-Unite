#!/bin/bash

# Eventyay Integrated Setup Script
# This script sets up both the tickets system and check-in app to work together

set -e

echo "🚀 Setting up Eventyay Integrated System..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

print_status "All prerequisites are installed."

# Setup Check-in App
print_status "Setting up Check-in App..."
cd eventyay-checkin

if [ ! -d "node_modules" ]; then
    print_status "Installing Node.js dependencies..."
    npm install
else
    print_status "Node.js dependencies already installed."
fi

print_success "Check-in app setup complete."
cd ..

# Setup Tickets System
print_status "Setting up Tickets System..."
cd eventyay-tickets

if [ ! -d "venv" ]; then
    print_status "Creating Python virtual environment..."
    python3 -m venv venv
fi

print_status "Activating virtual environment and installing dependencies..."
source venv/bin/activate
pip install --upgrade pip

# Install the package in development mode
if [ ! -f "venv/lib/python*/site-packages/eventyay.egg-link" ]; then
    print_status "Installing Eventyay Tickets in development mode..."
    pip install -e ".[dev]"
else
    print_status "Eventyay Tickets already installed."
fi

print_success "Tickets system setup complete."
cd ..

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p ssl
mkdir -p data/tickets
mkdir -p data/media

# Generate SSL certificates for local development (optional)
if [ ! -f "ssl/localhost.crt" ]; then
    print_status "Generating self-signed SSL certificates for local development..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/localhost.key \
        -out ssl/localhost.crt \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" 2>/dev/null || true
fi

# Create a simple development configuration
print_status "Creating development configuration..."
cat > .env << EOF
# Development Environment Configuration
DEBUG=true
POSTGRES_DB=eventyay
POSTGRES_USER=eventyay
POSTGRES_PASSWORD=eventyay
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
REDIS_URL=redis://redis:6379/0
PRETIX_URL=http://localhost:8000
PRETIX_CURRENCY=USD
PRETIX_INSTANCE_NAME=eventyay
PRETIX_DATADIR=/data
PRETIX_TRUST_X_FORWARDED_FOR=on
PRETIX_TRUST_X_FORWARDED_PROTO=on
EOF

print_success "Development configuration created."

# Create a startup script
print_status "Creating startup script..."
cat > start.sh << 'EOF'
#!/bin/bash

# Eventyay Integrated System Startup Script

set -e

echo "🚀 Starting Eventyay Integrated System..."

# Start the services
echo "Starting Docker services..."
docker-compose up -d postgres redis

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 10

# Run database migrations
echo "Running database migrations..."
docker-compose run --rm tickets python manage.py migrate

# Create superuser if it doesn't exist
echo "Creating superuser (if not exists)..."
docker-compose run --rm tickets python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(email='admin@eventyay.com').exists():
    User.objects.create_superuser('admin@eventyay.com', 'admin@eventyay.com', 'admin123')
    print('Superuser created: admin@eventyay.com / admin123')
else:
    print('Superuser already exists')
"

# Start all services
echo "Starting all services..."
docker-compose up -d

echo "✅ Eventyay system is starting up!"
echo ""
echo "📋 Access URLs:"
echo "   🎫 Tickets Admin: http://localhost:8000/control/"
echo "   📱 Check-in App: http://localhost:8080/"
echo "   🔧 API Docs: http://localhost:8000/api/v1/"
echo ""
echo "🔑 Default Admin Credentials:"
echo "   Email: admin@eventyay.com"
echo "   Password: admin123"
echo ""
echo "📊 To view logs: docker-compose logs -f"
echo "🛑 To stop: docker-compose down"
EOF

chmod +x start.sh

# Create a stop script
cat > stop.sh << 'EOF'
#!/bin/bash

echo "🛑 Stopping Eventyay Integrated System..."
docker-compose down
echo "✅ System stopped."
EOF

chmod +x stop.sh

print_success "Setup complete!"
print_status "To start the system, run: ./start.sh"
print_status "To stop the system, run: ./stop.sh"

echo ""
echo "📋 Next Steps:"
echo "1. Run './start.sh' to start the integrated system"
echo "2. Access the tickets admin at http://localhost:8000/control/"
echo "3. Access the check-in app at http://localhost:8080/"
echo "4. Create events and configure check-in lists in the admin"
echo "5. Use the check-in app to scan tickets and manage attendees"
echo ""
echo "🔧 For development:"
echo "- Tickets system code is in ./eventyay-tickets/src/"
echo "- Check-in app code is in ./eventyay-checkin/src/"
echo "- Both support hot reloading during development"
echo ""
print_success "Eventyay Integrated System setup is complete! 🎉"