# 🎫 Eventyay-Unite: Integrated Event Management Platform

> **A unified event management solution combining ticketing and check-in systems**

This repository integrates two powerful open-source event management systems:
- **Eventyay Tickets** (Django-based ticketing system)
- **Eventyay Check-in** (Vue.js-based check-in application)

## 🙏 Credits & Original Creators

This integration builds upon the excellent work of:

### 🎫 Eventyay Tickets
- **Original Repository**: [fossasia/eventyay-tickets](https://github.com/fossasia/eventyay-tickets)
- **Created by**: [FOSSASIA](https://github.com/fossasia)
- **Description**: A comprehensive event ticketing and management system based on Pretix
- **License**: Apache License 2.0

### 📱 Eventyay Check-in
- **Original Repository**: [fossasia/open-event-checkin](https://github.com/fossasia/open-event-checkin)
- **Created by**: [FOSSASIA](https://github.com/fossasia)
- **Description**: A modern Vue.js-based check-in application for events
- **License**: Apache License 2.0

**Special Thanks**: To the entire FOSSASIA community and all contributors who made these amazing systems possible. This integration simply brings them together for easier deployment and unified management.

A unified event management platform combining **Eventyay Tickets** (Django backend) and **Eventyay Check-in** (Vue.js frontend) for complete event ticketing and attendee management.

## 🏗️ System Architecture

The integrated system consists of:

- **Eventyay Tickets**: Django-based backend for ticket sales, event management, and API services
- **Eventyay Check-in**: Vue.js frontend for attendee check-in, QR code scanning, and badge generation
- **PostgreSQL**: Database for persistent data storage
- **Redis**: Caching and session management
- **Nginx**: Reverse proxy for unified access

## 🚀 macOS Setup Guide

### Prerequisites

Before setting up Eventyay on macOS, ensure you have the following installed:

#### Required Software

1. **Docker Desktop for Mac**
   ```bash
   # Download from: https://www.docker.com/products/docker-desktop/
   # Or install via Homebrew:
   brew install --cask docker
   ```

2. **Node.js (v18 or higher)**
   ```bash
   # Install via Homebrew:
   brew install node
   
   # Or download from: https://nodejs.org/
   # Verify installation:
   node --version
   npm --version
   ```

3. **Python 3.11+**
   ```bash
   # Install via Homebrew:
   brew install python@3.11
   
   # Or use pyenv for version management:
   brew install pyenv
   pyenv install 3.11.0
   pyenv global 3.11.0
   
   # Verify installation:
   python3 --version
   pip3 --version
   ```

4. **Git**
   ```bash
   # Usually pre-installed on macOS, or install via Homebrew:
   brew install git
   ```

#### Optional but Recommended

- **Homebrew** (Package manager for macOS):
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

- **PostgreSQL** (for local development without Docker):
  ```bash
  brew install postgresql@15
  brew services start postgresql@15
  ```

### Quick Start

#### Option 1: Docker Setup (Recommended for Production-like Environment)

1. **Clone and Setup**:
   ```bash
   git clone <repository-url>
   cd eventyay-integrated
   chmod +x setup.sh
   ./setup.sh
   ```

2. **Start the System**:
   ```bash
   ./start.sh
   ```

3. **Access the Applications**:
   - **Tickets Admin**: http://localhost:8000/control/
   - **Check-in App**: http://localhost:8080/
   - **API**: http://localhost:8000/api/v1/

#### Option 2: Local Development Setup (Faster for Development)

1. **Setup for Development**:
   ```bash
   chmod +x dev-setup.sh
   ./dev-setup.sh
   ```

2. **Start Development Servers**:
   ```bash
   # Start both services in separate terminals:
   ./start-dev.sh
   
   # Or start individually:
   ./start-backend.sh    # Django backend on port 8000
   ./start-frontend.sh   # Vue.js frontend on port 8080
   ```

### Default Credentials
- **Email**: `admin@eventyay.com`
- **Password**: `admin123`

## 👥 First-Time Setup Guide for New Users

### Complete Step-by-Step Setup (macOS)

If you're new to development or this is your first time setting up Eventyay, follow this detailed guide:

#### Step 1: Prepare Your Mac

1. **Open Terminal**:
   - Press `Cmd + Space`, type "Terminal", and press Enter
   - Or go to Applications > Utilities > Terminal

2. **Install Xcode Command Line Tools** (if not already installed):
   ```bash
   xcode-select --install
   ```
   - Click "Install" when prompted
   - This provides essential development tools

3. **Install Homebrew** (macOS package manager):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   - Follow the on-screen instructions
   - Add Homebrew to your PATH when prompted

#### Step 2: Install Required Software

1. **Install Docker Desktop**:
   ```bash
   brew install --cask docker
   ```
   - Or download from: https://www.docker.com/products/docker-desktop/
   - **Important**: Open Docker Desktop app and complete setup
   - Wait for Docker to start (whale icon in menu bar should be steady)

2. **Install Node.js**:
   ```bash
   brew install node
   ```
   - Verify: `node --version` (should show v18 or higher)

3. **Install Python**:
   ```bash
   brew install python@3.11
   ```
   - Verify: `python3 --version` (should show 3.11 or higher)

4. **Install Git** (usually pre-installed):
   ```bash
   git --version
   # If not installed:
   brew install git
   ```

#### Step 3: Download and Setup Eventyay

1. **Navigate to your desired directory**:
   ```bash
   cd ~/Desktop  # or wherever you want to install
   ```

2. **Clone the repository** (replace with actual repo URL):
   ```bash
   git clone <repository-url>
   cd eventyay-integrated
   ```

3. **Make setup scripts executable**:
   ```bash
   chmod +x setup.sh dev-setup.sh start.sh stop.sh check-system.sh
   ```

4. **Run system check** (recommended for first-time users):
   ```bash
   ./check-system.sh
   ```
   - This will verify all prerequisites are installed
   - Follow any recommendations in the output
   - If you see errors, fix them before proceeding

#### Step 4: Choose Your Setup Method

**For Beginners (Recommended)**: Use Docker setup
```bash
./setup.sh
```

**For Developers**: Use local development setup
```bash
./dev-setup.sh
```

#### Step 5: Start the System

**Docker Setup**:
```bash
./start.sh
```

**Development Setup**:
```bash
./start-dev.sh
```

#### Step 6: Verify Everything Works

1. **Wait for services to start** (may take 2-5 minutes first time)

2. **Test the applications**:
   - Open http://localhost:8000/control/ in your browser
   - Login with: `admin@eventyay.com` / `admin123`
   - Open http://localhost:8080/ in another tab

3. **If something doesn't work**:
   - Check the troubleshooting section below
   - Look at terminal output for error messages
   - Ensure Docker Desktop is running

### What Each Setup Does

#### Docker Setup (`./setup.sh`)
- ✅ **Best for**: Production-like environment, beginners
- ✅ **Includes**: PostgreSQL database, Redis cache, Nginx proxy
- ✅ **Pros**: Complete environment, matches production
- ❌ **Cons**: Slower startup, requires more resources

#### Development Setup (`./dev-setup.sh`)
- ✅ **Best for**: Active development, faster iteration
- ✅ **Includes**: SQLite database, direct server access
- ✅ **Pros**: Fast startup, easy debugging, hot reloading
- ❌ **Cons**: Different from production environment

### Next Steps After Setup

1. **Create your first event**:
   - Go to http://localhost:8000/control/
   - Navigate to "Events" > "Create Event"
   - Fill in event details

2. **Set up check-in**:
   - In your event, go to "Check-in" settings
   - Create check-in lists
   - Configure badge templates

3. **Test the check-in app**:
   - Open http://localhost:8080/
   - Follow the device registration process
   - Test scanning QR codes

### Understanding the File Structure

```
eventyay-integrated/
├── eventyay-tickets/     # Django backend (API, admin)
├── eventyay-checkin/     # Vue.js frontend (mobile app)
├── docker-compose.yml    # Docker configuration
├── nginx.conf           # Reverse proxy config
├── setup.sh            # Docker setup script
├── dev-setup.sh        # Development setup script
├── start.sh            # Start Docker services
├── stop.sh             # Stop Docker services
└── README.md           # This file
```

## 🔧 macOS Troubleshooting

### Common Issues and Solutions

#### 1. Docker Issues

**Problem**: "Docker daemon not running"
```bash
# Solution: Start Docker Desktop
open -a Docker
# Wait for Docker to start, then retry
```

**Problem**: "Port already in use"
```bash
# Check what's using the port
lsof -i :8000  # or :8080, :5432, :6379
# Kill the process if needed
kill -9 <PID>
```

#### 2. Python/Django Issues

**Problem**: "Python command not found" or version issues
```bash
# Check Python installation
which python3
python3 --version

# If using pyenv, ensure it's in your PATH
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc
```

**Problem**: "ImportError: attempted relative import with no known parent package"
```bash
# This is usually fixed by our setup, but if it persists:
cd eventyay-tickets/src
export DJANGO_SETTINGS_MODULE=settings
python manage.py runserver 8000
```

**Problem**: "Database migration errors"
```bash
# Reset database (development only)
cd eventyay-tickets
rm -rf data/db.sqlite3
source venv/bin/activate
cd src
python manage.py migrate
python manage.py createsuperuser
```

#### 3. Node.js/npm Issues

**Problem**: "npm command not found"
```bash
# Reinstall Node.js
brew uninstall node
brew install node
# Or use nvm for version management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.zshrc
nvm install 18
nvm use 18
```

**Problem**: "EACCES permissions errors"
```bash
# Fix npm permissions
sudo chown -R $(whoami) ~/.npm
# Or use a Node version manager like nvm
```

**Problem**: "Module not found" errors
```bash
# Clear npm cache and reinstall
cd eventyay-checkin
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

#### 4. Permission Issues

**Problem**: "Permission denied" when running scripts
```bash
# Make scripts executable
chmod +x setup.sh dev-setup.sh start.sh stop.sh
chmod +x start-*.sh
```

**Problem**: "Cannot create directory" errors
```bash
# Check and fix directory permissions
sudo chown -R $(whoami) /Users/$(whoami)/Desktop/event
chmod -R 755 /Users/$(whoami)/Desktop/event
```

#### 5. Network/Firewall Issues

**Problem**: "Connection refused" or "Network unreachable"
```bash
# Check if macOS firewall is blocking connections
# System Preferences > Security & Privacy > Firewall
# Allow incoming connections for Docker, Python, and Node.js

# Test local connectivity
curl http://localhost:8000/api/v1/
curl http://localhost:8080/
```

#### 6. Memory/Performance Issues

**Problem**: "System running slowly" or "Out of memory"
```bash
# Increase Docker memory allocation
# Docker Desktop > Settings > Resources > Memory (recommend 4GB+)

# Monitor resource usage
top -o cpu
# Or use Activity Monitor app
```

### Getting Help

If you encounter issues not covered here:

1. **Check the logs**:
   ```bash
   # Docker logs
   docker-compose logs tickets
   docker-compose logs checkin
   
   # Development logs
   # Check terminal output where services are running
   ```

2. **Verify system requirements**:
   ```bash
   # Run our comprehensive system check
   ./check-system.sh
   
   # Manual checks (if needed)
   docker --version
   docker-compose --version
   node --version
   npm --version
   python3 --version
   pip3 --version
   ```

3. **Clean restart**:
   ```bash
   # Stop everything
   ./stop.sh
   docker-compose down -v
   
   # Clean Docker
   docker system prune -f
   
   # Restart
   ./start.sh
   ```

### Performance Tips for macOS

- **Use SSD storage** for better Docker performance
- **Allocate sufficient RAM** to Docker Desktop (4GB+ recommended)
- **Enable file sharing optimization** in Docker Desktop settings
- **Use local development setup** (`./dev-setup.sh`) for faster iteration
- **Close unnecessary applications** to free up system resources

## 📋 System Components

### Eventyay Tickets (Backend)

**Technology Stack:**
- Django 5.1 with Django REST Framework
- PostgreSQL database
- Redis for caching
- Celery for background tasks
- OAuth2 authentication

**Key Features:**
- Event creation and management
- Ticket sales and order processing
- Check-in list management
- API endpoints for mobile apps
- Multi-organizer support
- Payment processing integration
- Reporting and analytics

**API Endpoints:**
- `/api/v1/organizers/` - Organizer management
- `/api/v1/organizers/{org}/events/` - Event management
- `/api/v1/organizers/{org}/events/{event}/checkinlists/` - Check-in lists
- `/api/v1/organizers/{org}/events/{event}/orders/` - Order management
- `/api/v1/organizers/{org}/checkin/redeem/` - Check-in processing

### Eventyay Check-in (Frontend)

**Technology Stack:**
- Vue.js 3 with Composition API
- Vite for build tooling
- Pinia for state management
- Tailwind CSS for styling
- QR code scanning capabilities

**Key Features:**
- QR code scanning for ticket validation
- Real-time attendee check-in
- Badge generation and printing
- Offline capability
- Multi-device support
- Event selection and management
- Statistics and reporting

## 🔧 Development

### Development Workflow

1. **Backend Development (Tickets):**
   ```bash
   cd eventyay-tickets
   source venv/bin/activate
   cd src
   python manage.py runserver 8000
   ```

2. **Frontend Development (Check-in):**
   ```bash
   cd eventyay-checkin
   npm run dev
   ```

3. **Database Operations:**
   ```bash
   # Run migrations
   docker-compose exec tickets python manage.py migrate
   
   # Create superuser
   docker-compose exec tickets python manage.py createsuperuser
   
   # Access database
   docker-compose exec postgres psql -U eventyay -d eventyay
   ```

### Project Structure

```
eventyay-integrated/
├── eventyay-tickets/          # Django backend
│   ├── src/pretix/           # Main application code
│   ├── pyproject.toml        # Python dependencies
│   └── Dockerfile            # Backend container
├── eventyay-checkin/         # Vue.js frontend
│   ├── src/                  # Frontend source code
│   ├── package.json          # Node.js dependencies
│   └── Dockerfile            # Frontend container
├── docker-compose.yml        # Service orchestration
├── nginx.conf               # Reverse proxy config
├── setup.sh                 # Setup script
├── start.sh                 # Startup script
└── stop.sh                  # Shutdown script
```

## 🔗 Integration Points

### API Integration

The check-in app communicates with the tickets backend through REST API:

1. **Authentication**: OAuth2 tokens or device authentication
2. **Event Data**: Fetches events and check-in lists
3. **Check-in Process**: Validates tickets and records attendance
4. **Real-time Updates**: WebSocket connections for live updates

### Data Flow

1. **Event Creation**: Admin creates events in tickets backend
2. **Check-in Setup**: Configure check-in lists and permissions
3. **Device Registration**: Register check-in devices via QR codes
4. **Attendee Check-in**: Scan tickets using check-in app
5. **Badge Generation**: Generate and print attendee badges
6. **Reporting**: View statistics and reports in both systems

## 🛠️ Configuration

### Environment Variables

**Tickets Backend:**
```env
DATABASE_URL=postgresql://eventyay:eventyay@postgres:5432/eventyay
REDIS_URL=redis://redis:6379/0
PRETIX_URL=http://localhost:8000
PRETIX_CURRENCY=USD
DEBUG=true
```

**Check-in Frontend:**
```env
VITE_PROD_API_URL=http://localhost:8000/api/v1
VITE_TEST_API_URL=http://localhost:8000/api/v1
VITE_LOCAL_PORT=8080
```

### Docker Services

- **postgres**: PostgreSQL database (port 5432)
- **redis**: Redis cache (port 6379)
- **tickets**: Django backend (port 8000)
- **checkin**: Vue.js frontend (port 8080)
- **nginx**: Reverse proxy (port 80)

## 📱 Usage Guide

### Setting Up an Event

1. **Access Admin Panel**: http://localhost:8000/control/
2. **Create Organization**: Set up your organization
3. **Create Event**: Add event details, dates, and settings
4. **Add Ticket Types**: Configure different ticket categories
5. **Create Check-in Lists**: Set up check-in points and rules
6. **Generate Device QR**: Create QR codes for check-in devices

### Check-in Process

1. **Access Check-in App**: http://localhost:8080/
2. **Device Authentication**: Scan device QR code
3. **Select Event**: Choose the event to manage
4. **Scan Tickets**: Use camera to scan attendee QR codes
5. **Generate Badges**: Create and print attendee badges
6. **View Statistics**: Monitor check-in progress

## 🔒 Security

- **API Authentication**: OAuth2 and token-based authentication
- **CORS Configuration**: Properly configured cross-origin requests
- **CSRF Protection**: Django CSRF middleware enabled
- **SSL/TLS**: HTTPS support for production deployments
- **Device Management**: Secure device registration and management

## 📊 Monitoring

### Health Checks

- **Backend Health**: http://localhost:8000/healthcheck/
- **Database Status**: PostgreSQL connection monitoring
- **Cache Status**: Redis connection monitoring

### Logging

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f tickets
docker-compose logs -f checkin
```

## 🚀 Production Deployment

### Environment Setup

1. **Configure Environment Variables**:
   - Set production database credentials
   - Configure Redis connection
   - Set proper CORS origins
   - Enable SSL/TLS

2. **Security Hardening**:
   - Use strong passwords
   - Enable HTTPS
   - Configure firewall rules
   - Set up monitoring

3. **Scaling Considerations**:
   - Use managed database services
   - Implement load balancing
   - Set up CDN for static files
   - Configure auto-scaling

## 🤝 Contributing

1. **Fork the repositories**
2. **Create feature branches**
3. **Make changes with tests**
4. **Submit pull requests**
5. **Follow coding standards**

## 📄 License

This project is licensed under the Apache License 2.0. See the LICENSE files in each repository for details.

## 🚀 Quick Reference

### Essential Commands

```bash
# System check (run first)
./check-system.sh

# Docker setup (production-like)
./setup.sh
./start.sh
./stop.sh

# Development setup (faster)
./dev-setup.sh
./start-dev.sh

# Individual services
./start-backend.sh   # Django on :8000
./start-frontend.sh  # Vue.js on :8080
```

### Important URLs

- **🎫 Admin Panel**: http://localhost:8000/control/
- **📱 Check-in App**: http://localhost:8080/
- **🔧 API Docs**: http://localhost:8000/api/v1/
- **📊 Health Check**: http://localhost:8000/healthcheck/

### Default Credentials

- **Email**: `admin@eventyay.com`
- **Password**: `admin123`

### File Structure Quick Guide

```
eventyay-integrated/
├── 🎫 eventyay-tickets/     # Django backend
├── 📱 eventyay-checkin/     # Vue.js frontend
├── 🐳 docker-compose.yml    # Docker orchestration
├── 🌐 nginx.conf           # Reverse proxy
├── ⚙️ setup.sh             # Production setup
├── 🔧 dev-setup.sh         # Development setup
├── 🔍 check-system.sh      # System verification
└── 📖 README.md            # This documentation
```

### Troubleshooting Quick Fixes

```bash
# Docker not working?
open -a Docker  # Start Docker Desktop

# Port conflicts?
lsof -i :8000   # Check what's using port 8000
kill -9 <PID>   # Kill the process

# Permission errors?
chmod +x *.sh   # Make scripts executable

# Clean restart?
./stop.sh && docker system prune -f && ./start.sh

# Development issues?
cd eventyay-tickets && source venv/bin/activate
cd eventyay-checkin && npm install
```

### Getting Help

1. **Check logs**: Look at terminal output where services are running
2. **Run system check**: `./check-system.sh`
3. **Read troubleshooting**: See macOS Troubleshooting section above
4. **Clean restart**: Stop everything, clean Docker, restart
5. **Check GitHub issues**: Look for similar problems in the repository

## 🆘 Support

- **Documentation**: Check the docs/ directories in each repository
- **Issues**: Report bugs in the respective GitHub repositories
- **Community**: Join the FOSSASIA community channels
- **Commercial Support**: Available through eventyay.com

## 🎉 Acknowledgments

- **FOSSASIA** and the **Eventyay Team** for creating the original ticketing system
- **FOSSASIA** and the **Open Event Community** for developing the check-in application
- **All original contributors** to both eventyay-tickets and open-event-checkin repositories
- **Contributors** who helped create this integration
- **Open Source Community** for the underlying technologies (Django, Vue.js, PostgreSQL, Redis, Docker)
- **Pretix**: Original ticketing system that Eventyay Tickets is based on
- **Vue.js Community**: For the excellent frontend framework
- **Django Community**: For the robust backend framework

### Repository Naming

**Suggested Repository Name**: `eventyay-unite`

**Alternative Names**:
- `eventyay-integrated`
- `eventyay-platform`
- `eventyay-complete`
- `eventyay-unified`

The name "Unite" reflects the integration of both systems while maintaining the Eventyay brand identity.

---

**Happy Event Management! 🎪**