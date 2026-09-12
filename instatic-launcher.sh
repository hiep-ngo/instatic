#!/usr/bin/env bash
# Instatic launcher - starts dev server and opens browser
export PATH="/home/n01d/.bun/bin:$PATH"

INSTATIC_DIR="/home/n01d/Projects/apps/instatic"
URL="http://localhost:5173/admin"

cd "$INSTATIC_DIR" || exit 1

# Check if server already running
if curl -s "http://localhost:5173" > /dev/null 2>&1; then
    echo "Instatic already running, opening browser..."
    xdg-open "$URL"
    exit 0
fi

# Start server in background
echo "Starting Instatic dev server..."
bun run dev &
SERVER_PID=$!

# Wait for server to be ready
echo "Waiting for server..."
for i in {1..30}; do
    if curl -s "http://localhost:5173" > /dev/null 2>&1; then
        echo "Server ready!"
        xdg-open "$URL"
        break
    fi
    sleep 1
done

# Keep script alive while server runs
wait $SERVER_PID
