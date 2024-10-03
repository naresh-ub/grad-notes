# # Start from the Manim base image
# FROM manimcommunity/manim:v0.18.0

# # Use root for installation processes
# USER root

# # Install system dependencies for Poetry
# RUN apt-get update && apt-get install -y \
#     curl \
#     poppler-utils \
#     libpoppler-cpp-dev \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

# # Install Poetry
# RUN curl -sSL https://install.python-poetry.org | python3 -

# # Ensure Poetry is available in the PATH
# ENV PATH="/manim/.local/bin:$PATH"

# # Verify Poetry installation
# RUN /manim/.local/bin/poetry --version

# # Install Jupyter Notebook and other pip-based dependencies
# COPY requirements.txt /tmp/

# # Display the contents of requirements.txt
# RUN cat /tmp/requirements.txt

# # Install dependencies from requirements.txt using pip
# RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# # Set the working directory
# WORKDIR /grad-notes

# # Copy pyproject.toml and poetry.lock* files to the working directory for jupyter-tikz installation
# COPY pyproject.toml poetry.lock* /grad-notes/

# # Install dependencies using Poetry without installing the project itself
# RUN /manim/.local/bin/poetry install --no-root

# # Copy the rest of the project files with correct ownership
# COPY . /grad-notes
# RUN chown -R root:root /grad-notes

# # Set the working directory for the project
# WORKDIR /grad-notes/source

# # Switch back to the non-root user
# ARG NB_USER=manimuser
# USER ${NB_USER}

# Start from the Manim base image
FROM manimcommunity/manim:v0.18.1

# Use root for installation processes
USER root

# Install required system dependencies for adding Python 3.11
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.11 as the default Python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# Verify the Python version
RUN python3 --version

# Install pip for Python 3.11
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

# Install Jupyter Notebook
RUN pip install notebook

# Copy requirements.txt file
COPY requirements.txt /tmp/

# Display the contents of requirements.txt
RUN cat /tmp/requirements.txt

# Install dependencies from requirements.txt file
RUN pip install -r /tmp/requirements.txt

# Copy project files
COPY . /grad-notes

# Set the working directory
WORKDIR /grad-notes/source

# Set non-root user
ARG NB_USER=manimuser
USER ${NB_USER}

# Ensure proper file ownership
COPY --chown=manimuser:manimuser . /grad-notes
