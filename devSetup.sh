#!/bin/bash

USERHOME=/home/$(whoami)
DOCKER_SOCKET=${DOCKER_SOCKET:-/var/run/docker.sock}
DOCKER_GROUP_ID=$(dscl . -read /Groups/docker | grep 'PrimaryGroupID:' |  awk '{print $2}')
CONTAINER_USER_NAME="$(whoami | sed 's/\./_/g')"
WORKSPACE=/home/$CONTAINER_USER_NAME/myworkspace

# Function to print usage
log_usage() {
    echo "Usage: $0 --build || --enter || --run || --remove || --removeImage || --exec"
}

# Function to build the Docker image
build_image() {
    echo "Building Docker image..."
    docker build --no-cache -t ray-build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=${DOCKER_GROUP_ID} --build-arg USER_NAME=$(whoami) .
}

# Function to enter the Docker container
enter_container() {
    echo "Entering the container..."
    docker exec -it ray-build /bin/bash --login
}

# Function to run the Docker container
run_container() {
    if [[ $(docker ps -q -f name=ray-build) ]]; then
        echo "Container 'ray-build' is already running."
    elif [[ $(docker ps -aq -f status=exited -f name=ray-build) ]]; then
        echo "Starting existing container 'ray-build'."
        docker start ray-build
    else
        echo "Running new Docker container mounting ${WORKSPACE}..."
        free_pages=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
        free_memory_kb=$(($free_pages * 4096))
        free_memory_mb=$(($free_memory_kb / 1024 / 1024))
        docker run -itd --name ray-build --shm-size=${free_memory_mb}mb --privileged --network host -v ${DOCKER_SOCKET}:${DOCKER_SOCKET} -v "$(pwd):${WORKSPACE}" ray-build
    fi
}

# Function to run a command inside the container
exec_command() {
    if [[ $(docker ps -q -f name=ray-build) ]]; then
        echo "Executing command inside 'ray-build' container..."
        docker exec -it ray-build "$@"
    else
        echo "Container 'ray-build' is not running. Please run the container first."
    fi
}

# Function to remove the Docker container
remove_container() {
    echo "Removing Docker container..."
    docker rm -f ray-build
}

# Function to remove the Docker container image
remove_container_image() {
    echo "Removing Docker container image..."
    docker rmi -f ray-build
}

# Check for options
if [[ "$#" -lt 1 ]]; then
    log_usage
    exit 1
fi

case "$1" in
    --build)
        build_image
        ;;
    --run)
        run_container
        enter_container
        ;;
    --enter)
        enter_container
        ;;
    --remove)
        remove_container
        ;;
    --removeImage)
        remove_container_image
        ;;
    --exec)

        shift
        exec_command "$@"
        ;;
    *)
        echo "Invalid option: $1"
        log_usage
        exit 1
        ;;
esac
