# syntax=docker/dockerfile:1.4

# 1. Use a Anaconda base image
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
    
# Define non-root user arguments.
ARG USER=jnbuser
ARG UID=1000

# Set default shell to `BASH`.
SHELL [ "/bin/bash", "-c" ]

# 2. Use `mamba` for creation
# and other manipulations as it is faster
# than `conda` (which is mainly used for activation).
RUN conda install -y -c conda-forge mamba

# 3. Create a non-privileged user.
RUN useradd -ms /bin/bash -u ${UID} ${USER}

# 4. Configure `conda` to make it accessible to the non-root user.
RUN mkdir -p /opt/conda/envs /opt/conda/pkgs && \
    chmod 755 /opt/conda/bin/conda && \
    chown ${USER}:${USER} /opt/conda/envs /opt/conda/pkgs
    
# 5. Set up Jupyter config and set default IP to 0.0.0.0
RUN mkdir -p /home/${USER}/.jupyter && \
    echo 'c.NotebookApp.ip = "0.0.0.0"' > /home/${USER}/.jupyter/jupyter_notebook_config.py && \
    echo 'c.ServerApp.ip = "0.0.0.0"' >> /home/${USER}/.jupyter/jupyter_notebook_config.py
    
# 6. Initialize `conda` as root.
RUN conda init bash && \
    echo '. /opt/conda/etc/profile.d/conda.sh' > /home/${USER}/.bashrc && \
    echo 'conda activate base' >> /home/${USER}/.bashrc
    
# 7. Set the ownership of the user's home directory.
RUN chown -R ${USER}:${USER} /home/${USER}

# Switch to the non-root user.
USER ${USER}

# 8. Create the directory
# that will contains
# the source code.
WORKDIR /app

# Define a mount point
# inside the container.
# Acts as a placeholder.
VOLUME /app

# Define a port especially
# for `Jupyter` Notebooks.
EXPOSE 8891

# Start an interactive shell.
CMD [ "bash" ]