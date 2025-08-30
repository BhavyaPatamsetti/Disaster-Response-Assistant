#!/bin/bash
echo "Creating portable Emergency Response App..."

# Create distribution folder
mkdir -p emergency-app-portable

# Copy essential files
cp docker-compose.yml emergency-app-portable/
cp Dockerfile.backend emergency-app-portable/
cp .env emergency-app-portable/
cp .dockerignore emergency-app-portable/
cp start-docker.sh emergency-app-portable/
cp requirements.txt emergency-app-portable/
cp -r app/ emergency-app-portable/
cp -r data/ emergency-app-portable/

# Create simple setup instructions
cat > emergency-app-portable/README.md << 'EOF'
# Emergency Response App - Portable Version

## Quick Setup (5 minutes)

### Prerequisites
1. Install Docker Desktop: https://docker.com/products/docker-desktop
2. Start Docker Desktop and wait for it to be ready

### Installation
```bash
# Make script executable
chmod +x start-docker.sh

# Run the app (this will download and build everything)
./start-docker.sh

# Wait 2-3 minutes for everything to start
```

### Testing
```bash
# Check if backend is healthy
curl http://localhost:8000/health

# Ask the AI a question
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question":"How do I treat a cut?"}'
```

### Access Points
- Backend API: http://localhost:8000, 8001, 8002
- All endpoints work on any of these ports

### Troubleshooting
- Ensure Docker Desktop is running
- Check logs: `docker-compose logs -f`
- Restart: `docker-compose down && docker-compose up -d --build`
- Stop: `docker-compose down`
EOF

# Create archive
tar -czf emergency-app-$(date +%Y%m%d).tar.gz emergency-app-portable/
echo "✅ Portable app created: emergency-app-$(date +%Y%m%d).tar.gz"
echo "📦 Size: $(du -h emergency-app-$(date +%Y%m%d).tar.gz | cut -f1)"
echo "🚀 Ready to share!"