# Contributing Guidelines

First, we recommend bringing your improvements and feature requests to [the upstream](https://github.com/gitpod-io/workspace-images/blob/master/CONTRIBUTING.md) as we'll sync upstream changes with ours.

If you love to submit your improvements here, keep reading.

## Code of Conduct and CLA

Please see our code of conduct at <https://policy.recaptime.tk/latest/community/code-of-conduct>. Our CLA is form of Linux DCO and some provisions regarding changes in OSS licenses (only applies in 
future contributions when in effect), among other legalese your employer may need. An `git commit --signoff` is fine, but we may implement an system soon.

## Contributing Image Improvements

- As usual, [open this repository in Gitpod](https://gitpod.io/#https://gitlab.com/gitpodify/gitpodified-workspace-images) and implement your changes as needed. Even if you don't have write access to
this repository please work on separate branches away from `recaptime-dev-mainline` to keep stability if you also fork our repo.
- Open an merge request and your image will be available under `quay.io/recaptime-dev/gitpod-workspace-images-artifacts:gl-gitpodify-gitpod-workspace-images-mr-<id>` and [you can also try it if needed](https://gitlab.com/gitpodify/bookish-potato).[^1]
- Keep in tabs between maintainer feedback and CI build status, and once everything is clear, you or the bot will merge it for you.

[^1]: Builds are ran on an separate repo specifically for that, with Docker CLI authenticated to RHQCR as an service account. Remember to wait for builds to turn green before trying to open it.

## Local dev environment setup

### Packages used

You need the following to proceed:

* Docker Engine/Desktop - Dazzle isn't tested yet on Podman.
* Dazzle - <https://github.com/moby/buildkit>
* bash and coreutils
* Optional tools including direnv, ShellCheck and Hadolint.
