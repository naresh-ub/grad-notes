# First stage: Use the Alpine image to install poppler-utils and pdftocairo
FROM alpine:latest AS poppler

# Install poppler and poppler-utils in Alpine
RUN apk --no-cache add poppler poppler-utils

# Verify pdftocairo installation
RUN pdftocairo -v

# Second stage: Use the Manim base image
FROM manimcommunity/manim:v0.18.0

# Use root for installation processes
USER root

# Install poppler utilities (from first stage)
COPY --from=poppler /usr/bin/pdftocairo /usr/bin/

# Verify pdftocairo in the final stage to confirm it's correctly installed
RUN pdftocairo -v

# Copy requirements.txt file early to avoid errors when installing dependencies
COPY requirements.txt /tmp/

# Display the contents of requirements.txt for debugging
RUN cat /tmp/requirements.txt

# Install dependencies from requirements.txt file
RUN pip install -r /tmp/requirements.txt

# Install Jupyter Notebook without using cache
RUN pip install notebook

# Copy the project files after the dependencies are installed
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


