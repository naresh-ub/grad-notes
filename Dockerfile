FROM manimcommunity/manim:v0.18.1

# Use root for installation processes
USER root

# Install Jupyter Notebook without using cache
RUN pip install --no-cache-dir notebook

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
    unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify pdftocairo installation
RUN pdftocairo -v

# Set the correct TEXMFHOME environment variable
ENV TEXMFHOME="/manim/.local/share/texmf"

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

# Install Python dependencies from requirements.txt without using cache
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy the project files
COPY . /grad-notes

# Set working directory
WORKDIR /grad-notes/source

# Ensure permissions are correctly set for non-root user to access the files
RUN chown -R manimuser:manimuser /grad-notes

# Set user back to the default non-root user for running notebooks
USER manimuser

# Set entrypoint to start Jupyter Notebook
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
