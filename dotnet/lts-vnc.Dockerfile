FROM quay.io/gitpodified-workspace-images/vnc

USER gitpod

# Install .NET SDK (LTS channel)
# Source: https://docs.microsoft.com/dotnet/core/install/linux-scripted-manual#scripted-install
RUN mkdir -p /home/gitpod/dotnet && curl -fsSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --install-dir /home/gitpod/dotnet
ENV DOTNET_ROOT=/home/gitpod/dotnet
ENV PATH=$PATH:/home/gitpod/dotnet

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