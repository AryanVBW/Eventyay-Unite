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
