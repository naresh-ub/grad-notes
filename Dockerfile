FROM manimcommunity/manim:v0.18.1

# Use root for installation processes
USER root

# Install Jupyter Notebook without using cache
RUN pip install notebook

# Install Poppler utilities for pdftocairo
RUN apt-get update && apt-get install -y \
    poppler-utils \
    libpoppler-cpp-dev

# Install LaTeX packages including pgfplots
RUN apt-get install -y \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-pictures \
    texlive-science

# Verify pdftocairo installation
RUN pdftocairo -v

# Copy requirements.txt file
COPY requirements.txt /tmp/

# Display the contents of requirements.txt
RUN cat /tmp/requirements.txt

# Install dependencies from requirements.txt file without using cache
RUN pip install -r /tmp/requirements.txt

COPY . /grad-notes

WORKDIR /grad-notes/source

ARG NB_USER=manimuser

USER ${NB_USER}

COPY --chown=manimuser:manimuser . /grad-notes
