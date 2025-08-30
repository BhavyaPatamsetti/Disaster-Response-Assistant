#!/bin/bash

echo "🚀 Starting Emergency Response App with Docker..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

echo "📦 Building and starting services..."
docker-compose up -d --build

echo "⏳ Waiting for services to start (this may take a few minutes)..."
sleep 60

echo "🏥 Checking if everything is working..."
if curl -s http://localhost:8000/health > /dev/null; then
    echo "✅ Backend is running!"
else
    echo "⚠️  Backend might still be starting..."
fi

echo ""
echo "🎉 Your app should be ready!"
echo "📱 Backend API: http://localhost:8000"
echo "🤖 AI Service: http://localhost:11434"
echo "📊 Health Check: http://localhost:8000/health"
echo ""
echo "To stop: docker-compose down"
echo "To view logs: docker-compose logs -f"