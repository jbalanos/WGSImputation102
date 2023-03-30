FROM app-bio/base:latest



ARG PYTHON_VERSION=3.10.10


RUN apt-get update
RUN apt-get install -y --no-install-recommends make  \
    build-essential \
    libssl-dev \ 
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev


ENV LANG=en_US.UTF-8 \
    PYENV_ROOT="/home/ubuntu/.pyenv" \
    PATH="/home/ubuntu/.pyenv/bin:/home/ubuntu/.pyenv/shims:$PATH"

# install pyenv & python
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
 && pyenv install ${PYTHON_VERSION} \
 && pyenv global ${PYTHON_VERSION} \
 && pip install --upgrade pip