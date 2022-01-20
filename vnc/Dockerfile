FROM quay.io/gitpodified-workspace-images/full:latest

# Install Xvfb, JavaFX-helpers, Openbox window manager and emacs GTK
RUN sudo install-packages xvfb x11vnc xterm openjfx libopenjfx-java openbox \
            emacs-gtk

# Overwrite this env variable to use a different window manager
ENV WINDOW_MANAGER="openbox"

USER root

# Change the default number of virtual desktops from 4 to 1 (footgun)
RUN sed -ri "s/<number>4<\/number>/<number>1<\/number>/" /etc/xdg/openbox/rc.xml

# Install novnc
RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify
COPY novnc-index.html /opt/novnc/index.html

# Add VNC startup script
COPY start-vnc-session.sh /usr/bin/
RUN chmod +x /usr/bin/start-vnc-session.sh

USER gitpod

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the X
# server is running on screen 0, and if not starts Xvfb, x11vnc and novnc.
RUN echo "export DISPLAY=:0" | tee --append ~/.bashrc && echo "[ ! -e /tmp/.X0-lock ] && (/usr/bin/start-vnc-session.sh &> /tmp/display-\${DISPLAY}.log)" | tee --append ~/.bashrc \
    echo "export DISPLAY=:0" | tee --append ~/.zshrc && echo "[ ! -e /tmp/.X0-lock ] && (/usr/bin/start-vnc-session.sh &> /tmp/display-\${DISPLAY}.log)" | tee --append ~/.zshrc

### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }

ARG imageArtifactTagName=quay.io/gitpodified-workspace-images/build-artifacts:123e4567-e89b-12d3-a456-426652340000
ARG buildId=123e4567-e89b-12d3-a456-426652340000
ARG maintainer="Recap Time Squad <docker+gp-ws-images@recaptime.tk>"
ARG gitRepo=https://gitlab.com/gitpodify/gitpodified-workspace-images
ARG commitId=0000000000000000000000000000
# First, bake image metadata for 'docker inspect'.
LABEL dev.gitpodify.customImage.buildId=${buildId} \
      dev.gitpodify.customImage.buildMaintainer=${maintainer} \
      org.opencontainers.image.licenses=MIT \
      org.opencontainers.image.source=${gitRepo} \
      dev.gitpodify.customImage.buildSource=${gitRepo} \
      dev.gitpodify.customImage.gitCommitSha=${commitId} \
      dev.gitpodify.image.artifactTag=${imageArtifactTagName}
# Then, load build ID, maintainer and source metadata as env vars
ENV GITPODIFY_CUSTOM_IMAGE_BUILD_ID=${buildId} \
    GITPODIFY_CUSTOM_IMAGE_ARTIFACT_TAG=${imageArtifactTagName} \
    GITPODIFY_CUSTOM_IMAGE_BUILD_MAINTAINER=${maintainer} \
    GITPODIFY_CUSTOM_IMAGE_BUILD_SOURCE=${gitRepo} \
    GITPODIFY_CUSTOM_IMAGE_BUILD_COMMIT_SHA=${commitId} \
    # GITPODIFY_IMAGE_BUILD_ID can be changed when built on other images based on it, so we're also provide
    # the GITPODIFY_BASE_BUILD_ID just in case.
    GITPODIFY_IMAGE_BUILD_ID=${buildId}
