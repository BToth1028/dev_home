#!/bin/bash
# Bash script to create .env.example files
# Run this from the Root-Arch_[251026-0900_GPTT]_V2 directory

echo "Creating .env.example files..."

# Node template
cat > templates/starter-node-service/.env.example << 'EOF'
# App Configuration
APP_PORT=3000

# Database
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/postgres

# Data Directories (optional - will use OS defaults if not set)
# APP_DATA_DIR=
# APP_LOG_DIR=
# APP_CACHE_DIR=
EOF

# Python template
cat > templates/starter-python-api/.env.example << 'EOF'
# App Configuration
APP_PORT=8000

# Database
DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres

# Data Directories (optional - will use OS defaults if not set)
# APP_DATA_DIR=
# APP_LOG_DIR=
# APP_CACHE_DIR=
EOF

echo "✓ Created templates/starter-node-service/.env.example"
echo "✓ Created templates/starter-python-api/.env.example"
echo ""
echo "Done! You can now use the templates."
