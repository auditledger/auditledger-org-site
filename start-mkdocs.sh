#!/bin/bash

# Audit Ledger MkDocs Server Management Script
# This script helps manage the MkDocs development server

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_PORT=8000
DEFAULT_HOST=127.0.0.1
VENV_DIR="venv"
SITE_DIR="site"

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

# Function to check if virtual environment exists
check_venv() {
    if [ ! -d "$VENV_DIR" ]; then
        print_error "Virtual environment not found at $VENV_DIR"
        print_status "Please run: python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
        exit 1
    fi
}

# Function to check if MkDocs is installed
check_mkdocs() {
    if ! source "$VENV_DIR/bin/activate" && command -v mkdocs >/dev/null 2>&1; then
        print_error "MkDocs not found in virtual environment"
        print_status "Please run: source venv/bin/activate && pip install -r requirements.txt"
        exit 1
    fi
}

# Function to kill existing MkDocs processes
kill_existing() {
    print_status "Checking for existing MkDocs processes..."

    # Find and kill MkDocs processes
    local pids=$(pgrep -f "mkdocs serve" 2>/dev/null || true)

    if [ -n "$pids" ]; then
        print_warning "Found existing MkDocs processes: $pids"
        print_status "Killing existing processes..."
        echo "$pids" | xargs kill -9 2>/dev/null || true
        sleep 2
        print_success "Existing processes terminated"
    else
        print_status "No existing MkDocs processes found"
    fi
}

# Function to clean up build artifacts
clean_build() {
    print_status "Cleaning build artifacts..."
    if [ -d "$SITE_DIR" ]; then
        rm -rf "$SITE_DIR"
        print_success "Build directory cleaned"
    fi
}

# Function to start MkDocs server
start_server() {
    local host=${1:-$DEFAULT_HOST}
    local port=${2:-$DEFAULT_PORT}

    print_status "Starting MkDocs server on $host:$port..."

    # Activate virtual environment and start server
    source "$VENV_DIR/bin/activate"

    # Start MkDocs server in background
    mkdocs serve --dev-addr="$host:$port" > mkdocs.log 2>&1 &
    local server_pid=$!

    # Wait a moment for server to start
    sleep 3

    # Check if server is running
    if kill -0 "$server_pid" 2>/dev/null; then
        print_success "MkDocs server started successfully!"
        print_status "Server PID: $server_pid"
        print_status "URL: http://$host:$port"
        print_status "Log file: mkdocs.log"
        print_status ""
        print_status "To stop the server, run: $0 stop"
        print_status "To view logs: tail -f mkdocs.log"

        # Save PID for later use
        echo "$server_pid" > .mkdocs.pid
    else
        print_error "Failed to start MkDocs server"
        print_status "Check mkdocs.log for details"
        exit 1
    fi
}

# Function to stop MkDocs server
stop_server() {
    print_status "Stopping MkDocs server..."

    # Try to read PID from file first
    if [ -f ".mkdocs.pid" ]; then
        local pid=$(cat .mkdocs.pid)
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            print_success "Server stopped (PID: $pid)"
        else
            print_warning "Process $pid not found"
        fi
        rm -f .mkdocs.pid
    fi

    # Kill any remaining MkDocs processes
    kill_existing
}

# Function to restart MkDocs server
restart_server() {
    local host=${1:-$DEFAULT_HOST}
    local port=${2:-$DEFAULT_PORT}

    print_status "Restarting MkDocs server..."
    stop_server
    sleep 2
    start_server "$host" "$port"
}

# Function to show server status
show_status() {
    print_status "MkDocs Server Status:"
    echo ""

    # Check if PID file exists
    if [ -f ".mkdocs.pid" ]; then
        local pid=$(cat .mkdocs.pid)
        if kill -0 "$pid" 2>/dev/null; then
            print_success "Server is running (PID: $pid)"
            print_status "URL: http://$DEFAULT_HOST:$DEFAULT_PORT"
        else
            print_warning "Server PID file exists but process is not running"
            rm -f .mkdocs.pid
        fi
    else
        print_warning "No PID file found"
    fi

    # Check for any MkDocs processes
    local pids=$(pgrep -f "mkdocs serve" 2>/dev/null || true)
    if [ -n "$pids" ]; then
        print_warning "Found MkDocs processes without PID file: $pids"
    fi
}

# Function to show logs
show_logs() {
    if [ -f "mkdocs.log" ]; then
        print_status "Showing MkDocs logs (last 50 lines):"
        echo ""
        tail -n 50 mkdocs.log
    else
        print_warning "No log file found"
    fi
}

# Function to show help
show_help() {
    echo "Audit Ledger MkDocs Server Management Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  start [HOST] [PORT]    Start MkDocs server (default: 127.0.0.1:8000)"
    echo "  stop                   Stop MkDocs server"
    echo "  restart [HOST] [PORT]  Restart MkDocs server"
    echo "  status                 Show server status"
    echo "  logs                   Show server logs"
    echo "  clean                  Clean build artifacts and stop server"
    echo "  help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start                    # Start on default host:port"
    echo "  $0 start 0.0.0.0 8080      # Start on all interfaces, port 8080"
    echo "  $0 restart                  # Restart on default host:port"
    echo "  $0 stop                     # Stop server"
    echo "  $0 status                   # Check if server is running"
    echo "  $0 logs                     # View server logs"
    echo ""
}

# Main script logic
case "${1:-start}" in
    start)
        check_venv
        check_mkdocs
        kill_existing
        clean_build
        start_server "$2" "$3"
        ;;
    stop)
        stop_server
        ;;
    restart)
        check_venv
        check_mkdocs
        restart_server "$2" "$3"
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    clean)
        stop_server
        clean_build
        print_success "Cleanup complete"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
