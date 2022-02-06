FROM quay.io/gitpodified-workspace-images/full

# Install the latest rr.
RUN __RR_VERSION__="5.5.0" \
 && cd /tmp \
 && wget -qO rr.deb https://github.com/mozilla/rr/releases/download/${__RR_VERSION__}/rr-${__RR_VERSION__}-Linux-$(uname -m).deb \
 && sudo dpkg -i rr.deb \
 && rm -f rr.deb

# Install Firefox build dependencies
# One-line setup command from:
# https://firefox-source-docs.mozilla.org/setup/linux_build.html#one-line-bootstrapping
ENV SHELL=/bin/bash
RUN sudo apt-get update \
 && git clone --progress --single-branch --depth=1 https://github.com/mozilla/gecko-dev/ /tmp/gecko \
 && cd /tmp/gecko \
 && ./mach bootstrap --application-choice=browser \
 && sudo apt-get remove -y nodejs nodejs-doc \
 && sudo rm -rf /tmp/gecko /var/lib/apt/lists/*

# Install moz-phab
ENV SHELL=/bin/bash
RUN sudo apt-get update \
 && pip3 install --no-cache-dir MozPhab \
 && echo "PATH=\"\$PATH:$HOME/.local/bin/moz-phab\"" >> $HOME/.bashrc \
 && sudo rm -rf /var/lib/apt/lists/*

# Install git-cinnabar.
RUN git clone --depth 1 https://github.com/glandium/git-cinnabar $HOME/.git-cinnabar \
 && $HOME/.git-cinnabar/git-cinnabar download \
 && echo "\n# Add git-cinnabar to the PATH." >> $HOME/.bashrc \
 && echo "PATH=\"\$PATH:$HOME/.git-cinnabar\"" >> $HOME/.bashrc
ENV PATH $PATH:$HOME/.git-cinnabar

# Inject the path update to the top as bash completion needs to call rustc
RUN sed -i '1s|^|PATH=\"\$PATH:$HOME/.cargo/bin/\"\n|' $HOME/.bashrc

# Point to the doc on how to contribute
RUN echo "echo 'How to contribute:'"  >> $HOME/.bashrc \
 && echo "echo 'https://firefox-source-docs.mozilla.org/contributing/contribution_quickref.html'" >> $HOME/.bashrc

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
