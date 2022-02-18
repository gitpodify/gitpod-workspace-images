FROM buildpack-deps:bullseye

ENV TRIGGER_BUILD=1

# Copy scripts to our image
COPY .gitlab/ci/scripts/ /usr/local/bin/
COPY devkit/bin/ /usr/local/bin/
COPY base/install-packages base/upgrade-packages /usr/local/bin/

# Run CI setup script without authenicating against Docker yet.
RUN SKIP_DOCKER_CLI_LOGIN=true ci-setup

#ENTRYPOINT [ "/usr/bin/dumb-init", "/bin/bash" ]
#CMD [ "-l" ]
