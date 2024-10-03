# Start from the Manim base image
FROM manimcommunity/manim:v0.18.0

# Use root for installation processes
USER root

# Install Jupyter Notebook without using cache
RUN pip install notebook

# Install poppler-utils and libpoppler in the Manim (Ubuntu-based) image
RUN apt-get update && apt-get install -y \
    poppler-utils \
    libpoppler-cpp-dev

# Verify pdftocairo is installed correctly
RUN pdftocairo -v

# Copy requirements.txt file
COPY requirements.txt /tmp/

# Display the contents of requirements.txt
RUN cat /tmp/requirements.txt

# Install dependencies from requirements.txt file
RUN pip install -r /tmp/requirements.txt

# Copy the project files
COPY . /grad-notes

# Set the working directory
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


