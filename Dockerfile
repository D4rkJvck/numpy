# syntax=docker/dockerfile:1.4

# Define the `python` version separately,
# as it will be easier to change.
ARG PYTHON_VERSION=3.10

# Choose `slim-buster` is a smaller version
# of the `python` image, based on `Debian Buster`
# with many unnecessary packages removed.
FROM python:${PYTHON_VERSION}-slim-buster

LABEL version=1.0

# Install the necessary system dependencies
# for the `conda` installation.
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    && rm -rf /var/lib/apt/lists/*

# Download and Install `Miniconda`.
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh

# Add to `PATH` to make `conda` and `mamba`
# accessible from anywhere within the container.
ENV PATH="/opt/conda/bin:${PATH}"

# Create the directory
# that will contains
# the source code.
WORKDIR /app

# Define a mount point
# inside the container.
VOLUME [ "/app" ]

# Define a port for
# Jupyter Notebook
EXPOSE 8891

HEALTHCHECK --interval=30s \
    --timeout=10s \
    --start-period=5s \
    --retries=3 \
    CMD curl http://localhost:8891 | exit 1

# Initialize conda and then start the bash shell with the environment activated
CMD ["bash", "-c", "source /opt/conda/etc/profile.d/conda.sh && conda init bash && bash"]