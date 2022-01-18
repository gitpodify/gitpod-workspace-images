<!-- markdowmlint-disable MD004 -->
# Changelog

We keep all the changes for both this fork and the upstream changes we merged. Anything in the `In this fork`
section with breaking changes (`BREAKING`) should read the linked issue for migration guide, although if you go alone,
please proceed at your own risk.

## In this fork

This section contains different changes we made in the images under the `gitpodified-workspace-images` RHQCR namespace, incluuding the stuff
happened in this repository. Keep scrolling for the upstream's changelog entries. For fully chronological changelogs, please see the Git commit
log/history for `recaptime-dev-mainline` branch. Dates written here in this section is in Philippine Standard Time.

### 2021-01-11 to 2021-01-20

* **CHORE**: Add support for custom tags and handle selective builds via wrapper
* **CI**: Update base config for local registry setup.
* **FEAT**: Add [bashbox](https://github.com/bashbox/bashbox) to `ws-full` image.
* **CHORE**: Configure Conventional Commits VSC extension and even add it to Gitpod config's `vscode.extensions` key.
* **CI**: Make `pull-image` CI script executable.
* **CHORE**: Update `pull-image` script to support skipping pulling images from remote repositories.
* **CHORE**: Disable autocommit in Conventional Commits extension
* **CHORE**: Fix syntax issue on `docker-build` CI script and implemented an quick refinement on` docker-cli-login` script.
* **FEAT**: Bale build-artifacts tag name and other metadata to `ws-base` and `ws-full` images
* **FIX**: More chaotic fixes to syntax errors on `docker-build` script.

## 2021-01-07 to 2021-01-10

After the bloddy debugging hell last week, the build works, but the tagging gone brr.

* **CHORE**: Enable debugging mode in `docker-build` CI script.
* **CI**: Add support for selectively build an specific image when `CI_SELECTIVE_BUILD` is set to true.
    * Currently supports just one context dir for now and we also setup an symlink at `selective-build-push` by the way.
* **FIX**: Fix an CI config bug in reason why `ws-full:build` failed to run
if `ws-base:build` doesn't exist.
* **CHORE**: Improve help text and skip failed-to-push tags in `publish-image` CI script.
* **FEAT**: Use Zsh as default shell, currently on `ws-full`.
* **REFRACTOR**: Revamp some global configs into default key.s
    * Because global `variables` isn't deprecated yet, we did an quick fix on that.
* **CHORE**: Add `commit-trigger-build-file` script with symlink `create-dummy-commit` for generating `.trigger-build` file.
* **CHORE**: Move base Zsh config and OhMyZsh install step to base image and add image metadata for debugging purposes and to allow auditing in the future.
* **FEAT**: Support build args logic stuff for `docker-build` CI script.
* **CHORE**: Update README with some additions and raise failure threshold for Hadolint to `warning`.
* **CHORE/MERGE**: Branch sync with upstream main branch from commit <https://github.com/gitpod-io/workspace-images/commit/f2d623ca9d270c2ce8560d2ca0f9ce71b105aff2>.
* **CHORE**: Optmize Rust layer to install additional tooling in one layer.
* **FIX**: Fix an bug on sourcing Nixery stuff in dash during build.
* **CI**: Handle image caching and trigger rebuilds in scheduled jobs
* **FIX**: Fix missing pyenv and Python shims on both Dockerfile and adding an Python-specific zshrc on `ws-full`.

### 2022-01-01 to 2021-01-06

Work still continues even on New Year's Day, but things will slow down a bit since the lead dev will do schoolwork by Sunday or Monday.

* **CHORE**: Add Docker-in-Docker related variables, as per <https://pythonspeed.com/articles/gitlab-build-docker-image/>.
* **DOCS**: Add authoring guidelines, among other things to contributing docs.
* **CI**: Add an while-loop script to time in when Docker daemon goes up, also lock daemon image to 20.10.12 in Alpine 3.15.
* **FIX**: Update default DIND port to probe to `2375`.[^1]
* **FEAT**: Sleep for another 15s after TCP socket is up in `wait-docker-tcp` CI script
* **FIX** Ensure `ws-base:build` actually builds image from `base/Dockerfile`, not from `full/Dockerfile`.
* **CHORE**: Add more usage text on `docker-build`, fix an bug in `publish-image` and disabled SC2086 in `lint-scripts`
    * We do not lnger rely on the sluggified value of `git rev-parse --abbrev-ref HEAD` and instead rely on
    `CI_COMMIT_REF_SLUG` variable instead if we're inside an GitLab CI runner.
* **CI**: Enable linting our CI scripts thrugh the `lint-scripts` script.

[^1]: Another one bites the dust, since [we used the wrong port again](https://gitlab.com/gitpodify/gitpodified-workspace-images/commit/d482a677b22f958cc2ead351df150c6dce8118ae) with `2376`. [Thanks GitLab Docs for the troubleshooting!](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#docker-cannot-connect-to-the-docker-daemon-at-tcpdocker2375-is-the-docker-daemon-running)

### 2021-12-28 to 2021-12-31

Last-minute changelogs before the ball drops to 2022 were included in the last weekdays of 2021.

* **CI**: Add `DOCKER_HOST` variable to fix `Is Docker daemon running` error on CI.
* **FEAT/CI**: Add `run-in-doppler` script as we're slowly migrating our secret management to Doppler.
* **BREAKING/CI**: Switch the image we using for builds to Alpine edge. The problem here why CI takes 4 minutes pulling 2-3 GBs of hentai from Red Hat Quay Container Registry
(just kidding, @ajhalili2006 didn't hid some sort of Linus S\*x Tips inside the image), among moving `before_script` commands to the base config.
* **FIX**: Fix syntax errors on `docker-cli-login` script finally after bloody 2~ days of debugging.
* **CHORE**: Update global `before_script` again into an one-item stuff in multi-line style.
* **CI**: Add `ws-base:build` job to the docker-build CI config, fix job rules for `ws-dotnet:lint` and add `findutils` Alpine package.
* **FIX**: Add compartibility if-then statement for var name migration stuff, fixed quick typo on ws-base:buid's needs key.
* **CHORE**: Enable command debugging via `set -x` to find why `ws-*:build` fails under the usage of `docker-build` script.
* **FIX**: Improve arg checking on `docker-build` script, may update later if needed.

### 2021-12-23 to 2021-12-26

* **REFRACTOR**: Refractored lint metascript for CI to fix some syntax issues and re-enabled `ws-full:build` step.
    * The `docker-build` script doesn't exist yet, so will be WIP for now.
* **CI**: Change default ws-image build artifacts repo to `quay.io/gitpodified-workspace-images/build-artifacts` as we use the bot account. Also add `docker-build` while the
ws-team upstream is working on upgrading the repo to per-chunk basis.
    * See commit <https://github.com/gitpod-io/dazzle/commit/ceaa19ef6562e03108c8ea9474d2c627a452a7ca> for details. We may need to setup an Docker registry as an service on GitLab CI for this to work.
* **CI**: Fix `docker-cli-login` script stuff.

### 2021-12-20 to 2021-12-22

* **CHORE**: Bump [Node.js LTS to `v16.13.1`](https://github.com/gitpod-io/workspace-images/pull/592) and [gopls to `v0.7.4`](https://github.com/gitpod-io/workspace-images/pull/590)
* **REFRACTOR**: Manually merge <https://github.com/gitpod-io/workspace-images/pull/587> by hand.
* **CHORE**: Move back other .NET-related Dockerfiles in subdirectories to the main `dotnet`, with `Dockerfile` as the file extension for syntax detection.
* **FIX**: Finally fix an bug on recursive SC script on why it only scans directories, along with improvements.
* **CI**: Update `needs` and add `rules` for the Docker linting stage in GitLab CI, extending previous work in <https://gitlab.com/gitpodify/gitpodified-workspace-images/commit/1e7d07a400f10aac5e45a40adab245e4b8e4a069>.
    * Additional fixes were commited to avoid missing job deps in the future.
* **CHORE**: Add support for exporting vars from `.env` file. The `.env.exmple` file provided should help contributors and core devs
to also add more vars as needed to simulate GitLab CI environment without `gitlab-runner` binary.
* **CHORE**: Update gitignore to ignore swap and dotenv files.
* **CHORE**: Add devkit scripts with symlinked `scripts` for ease + update Hadolint config

### 2021-12-18

* **CI**: Add needs option to each job to control job order in GitLab CI.

### 2021-12-11

* **CI**: Fix an bug on recursive ShellCheck script on also linting Dockerfiles with an `! -path` directive.

### 2021-12-04

- **FEAT**: Add `uuid` Ubuntu package to base image
* **CHORE**: Add an little trick in .envrc file to automagically simulate merge request events without GitLab Runner CLI.
* **DOCS**: Squash spelling bugs and list which packages we use is required or not in contributing docs
* **CHORE**: Add if-then logic on `.envrc` for setting `CI_PIPELINE_SOURCE` to `merge_request_event`.
* **CI**: Update root GitLab CI config to reflect filename changes since <https://gitlab.com/gitpodify/gitpodified-workspace-images/-/commit/0988751df8385ea407b27706b9b0bed5d0543261>.
* **FEAT**: Add ShellCheck, Hadolint and direnv to the full image.
* **FEAT**: Actually rebased against upstream default branch to keep things in sync.
* **CHORE**: Add some new variables automagically populated through `direnv` to simulate GitLab CI environment for scripts on localhost and Gitpod.
* **DOCS**: Update docs again regarding not using Dazzle in both README and in contributing docs. Also add some more docs on usage and FAQ.
* **CHORE**: Move the `shell-tools-and-hadolint` Dazzle layer before the prologue and also fix some stuff in `full` Dockerfile.
* **CI**: Add Hadolint config for ignoring some warnings and errors, particularly `sudo` usage.

### 2021-11-22 to 2021-11-23

* **CI:** Ditch Circle CI config and switch to GitHub Actions for meanwhile. Image builds are now handled by Quay for the `base` directory for now.
* **CHORE:** Migrated all Dockerfiles' base image to their RHQCR counterparts on `gitpodified-workspace-images`
* **CHORE:** Update security policy, contributing guidelines and README
* **CHORE**: Seperate changelog entries for this fork from upstream changes

## From upstream

A curated, chronologically ordered list of notable changes in [the upstream's default workspace images](https://hub.docker.com/r/gitpod/workspace-full), as we'll keep stuff in sync.

### 2021-08-01

- Bump Go version to 1.16.6
- Bump rust to 1.54.0
- Bump node.js to v14.17.4
- Bump docker-compose to 1.29.2
- Add golangci-lint
- Add ripgrep
- Add cargo-workspaces to cargo utils
- Add git-lfs

### 2021-06-04

- Bump Go version to 1.16.5
- Bump nvm.sh to v0.38.0
- Introduce pre-commit checks
- Run shellcheck in shell scripts

### 2020-06-03

- Bump Node.js version following a [security alert](https://twitter.com/liran_tal/status/1267519052731289600): [gitpod-io/workspace-images#243](https://github.com/gitpod-io/workspace-images/pull/243)

### 2020-06-02

- Upgrade all Go tools to get the latest `gopls`, and remove broken `golangci-lint` [gitpod-io/workspace-images#237](https://github.com/gitpod-io/workspace-images/pull/237)
- Make Python 3 the default `python` version (use `pyenv local 2.7.17` to go back to Python 2) [gitpod-io/workspace-images#214](https://github.com/gitpod-io/workspace-images/pull/214)

### 2020-05-12

- Downgrade Ruby `2.7.1` → `2.6.6` (because Solargraph doesn't support latest Bundler `2.1.4` yet) [e9281a20](https://github.com/gitpod-io/workspace-images/commit/e9281a207c4c6b4c7df2e91e9ec81f36ed0652ae)

### 2020-05-08

- Upgrade to Rust `1.43.1` [gitpod-io/workspace-images#230](https://github.com/gitpod-io/workspace-images/pull/230)
- Fix the persistence of Ruby gems in `/workspace/.rvm` with a custom `.rvmrc` [gitpod-io/workspace-images#223](https://github.com/gitpod-io/workspace-images/pull/223)
- Upgrade RVM's Ruby from `2.5` → `2.5.8` and `2.6` → `2.7.1` [gitpod-io/workspace-images#213](https://github.com/gitpod-io/workspace-images/pull/213)

### 2020-05-02

- Fix Ubuntu 20.04 based `gitpod/workspace-dotnet` and `gitpod/workspace-dotnet-vnc` images by installing .NET Core SDK 3.1 binaries [gitpod-io/workspace-images#218](https://github.com/gitpod-io/workspace-images/pull/218)

### 2020-04-29

- Best practice: Don't stay as `USER root` in `gitpod/workspace-full-vnc` [gitpod-io/workspace-images#215](https://github.com/gitpod-io/workspace-images/pull/215)
- Add bash auto-completion for `cargo` [gitpod-io/workspace-images#216](https://github.com/gitpod-io/workspace-images/pull/216)

### 2020-04-21

- Upgrade Pyenv's Python from `3.7.7` → `3.8.2` [gitpod-io/workspace-images#212](https://github.com/gitpod-io/workspace-images/pull/212)
- Drop support of .NET `2.2`, because it reached [end-of-life](https://dotnet.microsoft.com/platform/support/policy/dotnet-core) on 2019-12-23

### 2020-04-17

- Fix PostgreSQL image and pin to PostgreSQL version `12` [gitpod-io/workspace-images#209](https://github.com/gitpod-io/workspace-images/pull/209)
- Upgrade Rust `1.41.1` → `1.42.0` [gitpod-io/workspace-images#207](https://github.com/gitpod-io/workspace-images/pull/207)
- Fix MySQL image by updating mysql.cnf for MySQL `8`, fixes [gitpod-io/gitpod#1399](https://github.com/gitpod-io/gitpod/issues/1399)

### 2020-04-15

- Upgrade from Ubuntu `19.04` → Ubuntu `20.04 LTS`, because `19.04` reached end-of-life and all its apt packages got deleted [gitpod-io/gitpod#1398](https://github.com/gitpod-io/gitpod/issues/1398)
- Upgrade Java `11.0.5.fx-zulu` → `11.0.6.fx-zulu`

### 2020-04-06

- Make noVNC (virtual desktop) automatically reconnect if the connection is dropped, and enable noVNC toolbar [gitpod-io/workspace-images#170](https://github.com/gitpod-io/workspace-images/pull/170)

### 2020-03-30

- Upgrade Node.js from `v10` → `v12 LTS` (to pin a specific version, see [this workaround](https://github.com/gitpod-io/workspace-images/pull/178#issuecomment-602465333))

---
Inspired by [keepachangelog.com](https://keepachangelog.com/).
