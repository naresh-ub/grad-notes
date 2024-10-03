FROM manimcommunity/manim:v0.18.1

# Use root for installation processes
USER root

# Install Jupyter Notebook without using cache
RUN pip install notebook

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    poppler-utils \
    libpoppler-cpp-dev \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-pictures \
    texlive-science \
    texlive-luatex \
    texlive-xetex \
    wget \
    unzip

# Verify pdftocairo installation
RUN pdftocairo -v

# Download and manually install pgfplots LaTeX package
RUN mkdir -p /manim/.local/share/texmf/tex/latex/pgfplots && \
    wget -q https://mirrors.ctan.org/graphics/pgf/contrib/pgfplots.zip -O /tmp/pgfplots.zip && \
    unzip -q /tmp/pgfplots.zip -d /manim/.local/share/texmf/tex/latex/pgfplots && \
    mktexlsr

# Update LaTeX's file database to recognize the new package
RUN mktexlsr /manim/.local/share/texmf

# Verify that pgfplots is installed and available
RUN kpsewhich pgfplots.sty

# Set TEXINPUTS environment variable to ensure LaTeX finds packages in custom directories
ENV TEXINPUTS=".:/manim/.local/share/texmf/tex/latex//:"

# Copy requirements.txt file for additional Python dependencies
COPY requirements.txt /tmp/

# Display the contents of requirements.txt
RUN cat /tmp/requirements.txt

# Install Python dependencies from requirements.txt
RUN pip install -r /tmp/requirements.txt

# Copy the project files
COPY . /grad-notes

# Set working directory
WORKDIR /grad-notes/source

# Set user back to the default non-root user for running notebooks
ARG NB_USER=manimuser
USER ${NB_USER}

# Copy the project files with the correct ownership
COPY --chown=manimuser:manimuser . /grad-notes
