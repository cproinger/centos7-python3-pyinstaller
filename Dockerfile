FROM centos:7.6.1810
SHELL ["/bin/bash", "-c"]

ARG PYTHON_VERSION=3.7.3
ARG PYTHON_EXE=python3.7
ARG PYINSTALLER_VERSION=3.4

ENV PYPI_URL=https://pypi.python.org/
ENV PYPI_INDEX_URL=https://pypi.python.org/simple

COPY entrypoint.sh /entrypoint.sh

RUN \
    set -x \
    && echo 'start setting up centos-python3-pyinstaller image' \
    # what does this do?
    # update system
    # yum update -y \
    # install requirements (maybe also zlib-devel)
    && yum install -y gcc git make openssl-devel bzip2-devel libffi-devel \
    # # install pyenv
    # && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    # && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    # && source ~/.bashrc \
    # && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    # && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    # && source ~/.bashrc \
    # # install python
    # && PYTHON_CONFIGURE_OPTS="--enable-shared --with-ssl" pyenv install $PYTHON_VERSION \
    # && pyenv global $PYTHON_VERSION \
    && cd /usr/src \
    && curl -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar xzf Python-$PYTHON_VERSION.tgz \
    && cd Python-$PYTHON_VERSION \
    && ./configure --enable-shared --enable-unicode=ucs4 --prefix=/usr/local LDFLAGS="-Wl,--rpath=/usr/local/lib" \
    && make altinstall \
    && cd / \
    && rm /usr/src/Python-$PYTHON_VERSION.tgz \
    && python3.7 -v \
    && python3.7 -m pip install --upgrade pip \
    # install pyinstaller
    && python3.7 -m pip install pyinstaller==$PYINSTALLER_VERSION \
    && python3.7 -m pip install spaCy \
    && python3.7 -m spacy download en \
    && mkdir /src/ \
    && chmod +x /entrypoint.sh \
    && echo 'done setting up centos-pyhton3-pyinstaller image' \
    && yum clean all

VOLUME /src/
WORKDIR /src/

ENTRYPOINT ["/entrypoint.sh"]