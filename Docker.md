# Docker Setup for Chess Research (TODO)

Docker provides an isolated and consistent environment, making it perfect for projects that involve multiple tools and libraries. This document guides you through setting up your Chess Research environment within a Docker container.

## Dockerfile

The following `Dockerfile` is designed to set up an environment with Ubuntu, Python, Julia, and Stockfish:

```Dockerfile
# Start from an Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables to ensure non-interactive installation
ENV DEBIAN_FRONTEND=non-interactive

# Update and install necessary tools for Ubuntu, Python, and Julia
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python3 python3-pip git julia

# Clone your repository
RUN git clone https://github.com/LZDXN/Chess-Research-2023-Fall.git /app
WORKDIR /app

# Set up Python environment
RUN pip3 install -r requirements.txt

# Set up Julia and Python integration
RUN julia -e "using Pkg; Pkg.add(\"PyCall\"); Pkg.add(\"DataFrames\"); Pkg.add(\"Plots\"); Pkg.add(\"IJulia\")"

# Compile and set up Stockfish (Adjust as needed based on your Stockfish setup)
WORKDIR /app/stockfish-directory # Adjust this path to where Stockfish source will reside
RUN apt-get install -y make g++ && \
    # Clone or download Stockfish source here if necessary
    cd src && \
    make -j build ARCH=x86-64-modern

# Expose any necessary ports (optional)

# Command to run when the container starts
CMD ["/bin/bash"]
```

## Building the Docker Image

To build the Docker image using the above `Dockerfile`, run the following command:

```bash
docker build -t chess-research:latest .
```

## Running the Docker Image

Once the image is built, you can start a container using:

```bash
docker run -it chess-research:latest
```
