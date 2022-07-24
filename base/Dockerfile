FROM buildpack-deps:focal

COPY install-packages upgrade-packages /usr/local/bin/

### base ###
RUN yes | unminimize \
    && install-packages \
        zip \
        unzip \
        bash-completion \
        build-essential \
        ninja-build \
        htop \
        jq \
        less \
        locales \
        man-db \
        nano \
        ripgrep \
        software-properties-common \
        sudo \
        time \
        emacs-nox \
        vim \
        multitail \
        lsof \
        ssl-cert \
        fish \
        zsh \
        uuid \
        uuid-runtime \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8

### Update and upgrade the base image ###
RUN upgrade-packages

### Git ###
RUN add-apt-repository -y ppa:git-core/ppa \
    && install-packages git git-lfs

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers \
    # To emulate the workspace-session behavior within dazzle build env
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 \" (%s)\") $ '" ; } >> .bashrc

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    # create .bashrc.d folder and source it in the bashrc
    mkdir -p /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> /home/gitpod/.bashrc && \
    # create a completions dir for gitpod user
    mkdir -p /home/gitpod/.local/share/bash-completion/completions

# configure git-lfs
RUN sudo git lfs install --system \
    && sudo chown gitpod ~/.gitconfig || true

# setup omz stuff
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && rm -v ~/.zshrc \
    # Change default shell to Zsh
    && sudo chsh -s /bin/zsh gitpod \
    # Warm up directory for customizing zshrc shell :)
    && mkdir /home/gitpod/.gitpodify/custom-zshrc.d -p
COPY --chown=gitpod:gitpod base.zshrc /home/gitpod/.zshrc
COPY --chown=gitpod:gitpod zshrc.d /home/gitpod/.zshrc.d

# Custom PATH additions
ENV PATH=/usr/games:$PATH

ARG maintainer="Recap Time Squad <docker+gp-ws-images@recaptime.tk>"
ARG gitRepo=https://gitlab.com/gitpodify/gitpodified-workspace-images
# First, bake image metadata for 'docker inspect'.
LABEL dev.gitpodify.baseImage.buildMaintainer=${maintainer} \
      org.opencontainers.image.licenses=MIT \
      org.opencontainers.image.source=${gitRepo}

COPY --chown=gitpod:gitpod .build-info /home/gitpod/.gitpodify/ws-image-metadata

CMD [ "/usr/bin/zsh", "-l" ]
