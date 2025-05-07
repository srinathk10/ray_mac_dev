# Use the official Ubuntu image as a base
FROM ubuntu:20.04

# Set environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set the time zone to UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update package list and install necessary system packages and developer tools
RUN apt-get update && \
    apt-get install -y \
    wget \
    bzip2 \
    git \
    build-essential \
    curl \
    clang-12 \
    pkg-config \
    psmisc \
    unzip \
    libc6 \
    libc6-dev \
    qemu-user-static \
    vim \
    nano \
    gdb \
    make \
    strace \
    htop \
    tmux \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Set the user and group ID to match the host user and group
ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
ENV USER_NAME=${USER_NAME//./_}

# Create group and user
RUN groupadd -g ${GROUP_ID} docker || echo "Docker group already exists or GID in use." && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash ${USER_NAME} || echo "User already exists." && \
    usermod -aG docker ${USER_NAME} && \
    usermod -aG sudo ${USER_NAME}

# Add passwordless sudo entry for the user
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Miniconda for ARM architecture
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Update PATH environment variable
ENV PATH=/opt/conda/bin:$PATH

# Switch to the user
USER ${USER_NAME}

# Set the user's home directory as the working directory
WORKDIR /home/${USER_NAME}/myworkspace

# Copy the environment.yml file to the working directory
COPY env/environment.yml .

# Create the Conda environment
RUN conda env create -f environment.yml

# Activate the Conda environment and customize the prompt
RUN echo "source activate myenv" >> ~/.bashrc && \
    echo 'export PS1="(container) [\u@\h \W]\$ "' >> ~/.bashrc

# Ensure the user's bin directory is in the PATH
ENV PATH="/home/${USER_NAME}/bin:${PATH}"

# Install NVM and Node.js 14
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 14 && \
    nvm use 14 && \
    nvm alias default 14

# Prompt
RUN echo "export force_color_prompt=yes" >> ~/.bashrc && \
    echo "PS1='\\u@\\h$ '" >> ~/.bashrc

# Set the default command
CMD ["/bin/bash"]
