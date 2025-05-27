#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting local development environment...${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker first."
    exit 1
fi

# Start DynamoDB Local
echo -e "${GREEN}Starting DynamoDB Local...${NC}"
docker run -d -p 8000:8000 --name dynamodb-local amazon/dynamodb-local

# Wait for DynamoDB to be ready
echo "Waiting for DynamoDB to be ready..."
sleep 5

# Create the Course table
echo -e "${GREEN}Creating Course table...${NC}"
aws dynamodb create-table \
    --table-name Course \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --endpoint-url http://localhost:8000

# Start the backend with SAM
echo -e "${GREEN}Starting backend with SAM...${NC}"
cd backend-ald
sam local start-api --env-vars env.json &

# Wait for the backend to be ready
echo "Waiting for backend to be ready..."
sleep 10

# Start the frontend
echo -e "${GREEN}Starting frontend...${NC}"
cd ../web-s3
npm run dev

# Cleanup function
cleanup() {
    echo -e "${BLUE}Cleaning up...${NC}"
    docker stop dynamodb-local
    docker rm dynamodb-local
    pkill -f "sam local start-api"
    exit 0
}

# Register cleanup function
trap cleanup SIGINT SIGTERM

# Keep the script running
wait 