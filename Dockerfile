# syntax=docker/dockerfile:1.4

# Use a Anaconda base image
# to simplify environment
# creation and activation.
FROM continuumio/miniconda3

LABEL org.opencontainers.image.version="2.0" \
    org.opencontainers.image.title="Interactive Mamba Environment" \
    org.opencontainers.image.description="Docker image designed for interactive Numpy and Jupyter environment with Mamba." \
    org.opencontainers.image.authors="D4rkJvck d4rkjvck@gmail.com" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="" \
    org.opencontainers.image.source="github.com/D4rkJvck/numpy.git" \
    org.opencontainers.image.documentation=""

# Set default shell to `BASH`.
SHELL [ "/bin/bash", "-c" ]

# Use `mamba` for creation
# and other manipulations as it is faster
# than `conda` (which is mainly used for activation).
RUN conda install -y -c conda-forge mamba

# Create the directory
# that will contains
# the source code.
WORKDIR /app

# Define a mount point
# inside the container.
# Acts as a placeholder.
VOLUME [ "/app" ]

# Define a port especially
# for `Jupyter` Notebooks.
EXPOSE 8891

# Start an interactive shell.
CMD [ "bash" ]