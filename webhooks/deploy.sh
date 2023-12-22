#!/bin/bash

# Define variables
CONTAINER_NAME="YOUR_CONTAINER_NAME"
IMAGE_NAME="YOUR_IMAGE_NAME"
REPO_URL="https://YOUR_TOKEN@github.com/your-project/your-repo.git"
BRANCH_NAME="main"
PROJECT_DIR="/home/user/project_folder"
LOG_FILE="/home/user/pipeline.log"

# Log start of the script
echo "Script started by user $(whoami) at $(date)" >> "$LOG_FILE"

# Enable debugging output and error handling
set -xe

# Navigate to the project directory
cd "$PROJECT_DIR"

# Pull the latest changes from the repository
git pull "$REPO_URL" "$BRANCH_NAME"

# Check if the container exists and is running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME exists and is running. Stopping and removing..."
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
fi

# Build a new Docker image
docker build -t "$IMAGE_NAME" .

# Run the new Docker container with the new image
docker run -d -p 3000:3000 --restart always --name "$CONTAINER_NAME" "$IMAGE_NAME"

echo "Container $CONTAINER_NAME has been successfully deployed." >> "$LOG_FILE"
