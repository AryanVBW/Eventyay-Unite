#!/bin/bash

# System Check Script for Eventyay on macOS
# This script verifies that all prerequisites are installed and configured correctly

set -e

echo "🔍 Eventyay System Check for macOS"
echo "====================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

ERROR_COUNT=0
WARNING_COUNT=0

# Check macOS version
print_status "Checking macOS version..."
MAC_VERSION=$(sw_vers -productVersion)
print_success "macOS version: $MAC_VERSION"

# Check if running on Apple Silicon or Intel
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    print_success "Architecture: Apple Silicon (M1/M2)"
else
    print_success "Architecture: Intel x86_64"
fi

echo ""
print_status "Checking required software..."
echo ""

# Check Docker
print_status "Checking Docker..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    print_success "Docker installed: $DOCKER_VERSION"
    
    # Check if Docker daemon is running
    if docker info &> /dev/null; then
        print_success "Docker daemon is running"
    else
        print_error "Docker daemon is not running. Please start Docker Desktop."
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
else
    print_error "Docker is not installed. Install with: brew install --cask docker"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check Docker Compose
print_status "Checking Docker Compose..."
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version | cut -d' ' -f4 | cut -d',' -f1)
    print_success "Docker Compose installed: $COMPOSE_VERSION"
else
    print_error "Docker Compose is not installed. It should come with Docker Desktop."
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check Node.js
print_status "Checking Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | cut -d'v' -f2)
    
    if [[ $NODE_MAJOR -ge 18 ]]; then
        print_success "Node.js installed: $NODE_VERSION (✓ >= v18)"
    else
        print_warning "Node.js version $NODE_VERSION is older than recommended v18+"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
else
    print_error "Node.js is not installed. Install with: brew install node"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check npm
print_status "Checking npm..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm installed: $NPM_VERSION"
else
    print_error "npm is not installed. It should come with Node.js."
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check Python
print_status "Checking Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)
    
    if [[ $PYTHON_MAJOR -eq 3 && $PYTHON_MINOR -ge 11 ]]; then
        print_success "Python installed: $PYTHON_VERSION (✓ >= 3.11)"
    else
        print_warning "Python version $PYTHON_VERSION is older than recommended 3.11+"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
else
    print_error "Python 3 is not installed. Install with: brew install python@3.11"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check pip
print_status "Checking pip..."
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 --version | cut -d' ' -f2)
    print_success "pip installed: $PIP_VERSION"
else
    print_error "pip3 is not installed. It should come with Python."
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check Git
print_status "Checking Git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    print_success "Git installed: $GIT_VERSION"
else
    print_error "Git is not installed. Install with: brew install git"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

echo ""
print_status "Checking optional software..."
echo ""

# Check Homebrew
print_status "Checking Homebrew..."
if command -v brew &> /dev/null; then
    BREW_VERSION=$(brew --version | head -n1 | cut -d' ' -f2)
    print_success "Homebrew installed: $BREW_VERSION"
else
    print_warning "Homebrew is not installed. Recommended for easy package management."
    print_warning "Install with: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    WARNING_COUNT=$((WARNING_COUNT + 1))
fi

# Check PostgreSQL (optional)
print_status "Checking PostgreSQL (optional)..."
if command -v psql &> /dev/null; then
    POSTGRES_VERSION=$(psql --version | cut -d' ' -f3)
    print_success "PostgreSQL installed: $POSTGRES_VERSION (optional for local development)"
else
    print_warning "PostgreSQL not installed (optional). Install with: brew install postgresql@15"
fi

echo ""
print_status "Checking system resources..."
echo ""

# Check available memory
MEMORY_GB=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
print_status "Available RAM: ${MEMORY_GB}GB"
if [[ $MEMORY_GB -ge 8 ]]; then
    print_success "RAM is sufficient for Docker setup (${MEMORY_GB}GB >= 8GB)"
elif [[ $MEMORY_GB -ge 4 ]]; then
    print_warning "RAM is minimal for Docker setup (${MEMORY_GB}GB). Consider using dev-setup.sh instead."
    WARNING_COUNT=$((WARNING_COUNT + 1))
else
    print_error "RAM is insufficient for Docker setup (${MEMORY_GB}GB < 4GB). Use dev-setup.sh instead."
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check available disk space
DISK_SPACE=$(df -h . | awk 'NR==2 {print $4}' | sed 's/Gi//')
print_status "Available disk space: ${DISK_SPACE}GB"
if [[ $(echo "$DISK_SPACE > 10" | bc -l) -eq 1 ]]; then
    print_success "Disk space is sufficient (${DISK_SPACE}GB > 10GB)"
else
    print_warning "Disk space is low (${DISK_SPACE}GB). Docker images require ~5GB."
    WARNING_COUNT=$((WARNING_COUNT + 1))
fi

echo ""
print_status "Checking network connectivity..."
echo ""

# Check internet connectivity
if ping -c 1 google.com &> /dev/null; then
    print_success "Internet connectivity: OK"
else
    print_warning "Internet connectivity: Limited. May affect Docker image downloads."
    WARNING_COUNT=$((WARNING_COUNT + 1))
fi

# Check if ports are available
print_status "Checking port availability..."
PORTS=("8000" "8080" "5432" "6379")
for port in "${PORTS[@]}"; do
    if lsof -i :$port &> /dev/null; then
        print_warning "Port $port is in use. May conflict with Eventyay services."
        WARNING_COUNT=$((WARNING_COUNT + 1))
    else
        print_success "Port $port is available"
    fi
done

echo ""
echo "====================================="
echo "📊 System Check Summary"
echo "====================================="

if [[ $ERROR_COUNT -eq 0 && $WARNING_COUNT -eq 0 ]]; then
    print_success "✅ All checks passed! Your system is ready for Eventyay."
    echo ""
    echo "🚀 Next steps:"
    echo "   1. Run './setup.sh' for Docker setup (recommended)"
    echo "   2. Or run './dev-setup.sh' for development setup"
elif [[ $ERROR_COUNT -eq 0 ]]; then
    print_warning "⚠️  System check completed with $WARNING_COUNT warning(s)."
    echo "   Your system should work, but consider addressing the warnings above."
    echo ""
    echo "🚀 You can proceed with setup:"
    echo "   1. Run './setup.sh' for Docker setup"
    echo "   2. Or run './dev-setup.sh' for development setup"
else
    print_error "❌ System check failed with $ERROR_COUNT error(s) and $WARNING_COUNT warning(s)."
    echo "   Please fix the errors above before proceeding with setup."
    echo ""
    echo "📋 Common fixes:"
    echo "   • Install missing software using Homebrew"
    echo "   • Start Docker Desktop if installed"
    echo "   • Free up disk space if needed"
    echo "   • Check the troubleshooting section in README.md"
fi

echo ""
echo "📖 For detailed setup instructions, see README.md"
echo "🔧 For troubleshooting help, see the macOS Troubleshooting section"
echo ""