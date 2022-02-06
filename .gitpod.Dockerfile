FROM quay.io/gitpodified-workspace-images/full:latest

ENV RETRIGGER=1

ENV BUILDKIT_VERSION=0.9.3
ENV BUILDKIT_FILENAME=buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz

# Install Buildkit, Dazzle and Skopeo.
RUN sudo su -c "cd /usr; curl -L https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/${BUILDKIT_FILENAME} | tar xvz" \
  && curl -sSL https://github.com/gitpod-io/dazzle/releases/download/v0.1.6/dazzle_0.1.6_Linux_x86_64.tar.gz | sudo tar -xvz -C /usr/local/bin
RUN . /etc/os-release \
  && echo "deb [signed-by=/usr/share/keyrings/libcontainers-redhat-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
  && curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo gpg --dearmor --output /usr/share/keyrings/libcontainers-redhat-archive-keyring.gpg \
  && sudo install-packages skopeo
