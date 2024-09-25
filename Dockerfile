# Use an Ubuntu image or another suitable base image
FROM ubuntu:20.04

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory to a consistent path
WORKDIR /usr/src/app

# Copy your bash script into the container
COPY ubuntu_deploy_script.sh .

# Make the script executable
RUN chmod +x ubuntu_deploy_script.sh

# Install required dependencies
RUN apt update && apt install -y \
    build-essential \
    cmake \
    mesa-common-dev \
    git \
    wget

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt update && apt install cuda-toolkit-12-6 -y

# Run the script to build the binary
CMD ./ubuntu_deploy_script.sh