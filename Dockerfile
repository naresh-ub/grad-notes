# Start from the Manim base image
FROM manimcommunity/manim:v0.18.0

# Use root for installation processes
USER root

# Install system dependencies for Poetry
RUN apt-get update && apt-get install -y \
    curl \
    poppler-utils \
    libpoppler-cpp-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Ensure Poetry is available in the PATH
ENV PATH="/root/.local/bin:$PATH"

# Install Jupyter Notebook and other pip-based dependencies
COPY requirements.txt /tmp/

# Display the contents of requirements.txt
RUN cat /tmp/requirements.txt

# Install dependencies from requirements.txt using pip
RUN pip install -r /tmp/requirements.txt

# Set the working directory
WORKDIR /grad-notes

# Copy pyproject.toml and poetry.lock* files to the working directory for jupyter-tikz installation
COPY pyproject.toml poetry.lock* /grad-notes/

# Install only jupyter-tikz using Poetry
RUN poetry install --no-root

# Copy the rest of the project files
COPY . /grad-notes

# Set the working directory for the project
WORKDIR /grad-notes/source

# Switch back to the non-root user
ARG NB_USER=manimuser
USER ${NB_USER}

# Ensure the ownership of the files is correct for the non-root user
COPY --chown=manimuser:manimuser . /grad-notes

# FROM manimcommunity/manim:v0.18.0

# # Use root for installation processes
# USER root

# # Install Jupyter Notebook without using cache
# RUN pip install notebook

# # Copy requirements.txt file
# COPY requirements.txt /tmp/

# # Display the contents of requirements.txt
# RUN cat /tmp/requirements.txt

# # Install dependencies from requirements.txt file without using cache
# RUN pip install -r /tmp/requirements.txt

# COPY . /grad-notes

# WORKDIR /grad-notes/source

# ARG NB_USER=manimuser

# USER ${NB_USER}

# COPY --chown=manimuser:manimuser . /grad-notes
# # COPY --chown=manimuser:manimuser . /manim


