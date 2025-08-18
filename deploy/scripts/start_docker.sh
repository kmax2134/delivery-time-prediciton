#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 348888692177.dkr.ecr.us-east-1.amazonaws.com

echo "Pulling Docker image..."
docker pull 348888692177.dkr.ecr.us-east-1.amazonaws.com/deliver_time_prediction:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=delivery_time_pred)" ]; then
    echo "Stopping existing container..."
    docker stop delivery_time_pred
fi

if [ "$(docker ps -aq -f name=delivery_time_pred)" ]; then
    echo "Removing existing container..."
    docker rm delivery_time_pred
fi

echo "Starting new container..."
docker run -d -p 80:8000 --name delivery_time_pred -e DAGSHUB_USER_TOKEN=8e2ce4cc0285b9d02f188a78021c6b2f65604c9a 348888692177.dkr.ecr.us-east-1.amazonaws.com/deliver_time_prediction:latest

echo "Container started successfully."
