# Contributing Guidelines/Docs

First, we recommend bringing your improvements and feature requests to [the upstream](https://github.com/gitpod-io/workspace-images/blob/master/CONTRIBUTING.md) as we'll sync upstream changes with ours.

If you love to submit your improvements here, keep reading this contributing guidelines. Your participation to the project is covered by
our community code of conduct, which is available at <https://policy.recaptime.tk/latest/community/code-of-conduct>.

## DCO and CLA

Our CLA is form of Linux DCO and some provisions regarding changes in OSS licenses (only applies in 
future contributions when in effect), among other legalese your employer may need for compliance with copyright laws.
An `git commit --signoff` is fine, but we may implement an system soon.

**Recap Time Squad members**: As much as possible, use your `recaptime.(tk|dev)` email address in commits to keep CLA checks green. If you use an
personal email address OR use GPG commit signing in commits, checks might go brrr.

Remember that trivial contributions do not require an CLA to be signed before merging, but it's at reviewing maintainer chore to decide if it's an
non-trival or not, so ask it before or during review.

## Contributing Image Improvements

- As usual, [open this repository in Gitpod](https://gitpod.io/#https://gitlab.com/gitpodify/gitpodified-workspace-images) and implement your changes as needed. Even if you don't have write access to
this repository please work on separate branches away from `recaptime-dev-mainline` to keep stability if you also fork our repo.[^2]
- Open an merge request and your image will be available under `quay.io/recaptime-dev/gitpod-workspace-images-artifacts:gl-gitpodify-gitpod-workspace-images-mr-<id>`
and [you can also try it if needed](https://gitlab.com/gitpodify/bookish-potato).[^1]
- Keep in tabs between maintainer feedback and CI build status, and once everything is clear, our bots will merge it for you after
final approval (hint: maintainer approves the MR and adds `LGTM` label).

[^1]: Builds are ran on an separate repo specifically for that, with Docker CLI authenticated to RHQCR as an service account. Remember to wait for builds to turn green before trying to open it.
[^2]: While Andrei Jiroh do commiting stuff straight to the main branch, he avoids not to do commit history rewrite chaos other than keeping in sync with the upstream.

## Authoring Guidelines

These guidelines are not strict rules, other than the commit messages. Some stuff are an work in progress right now in this section, especially on
the changelog side.

### Commit Messages

It's some form of Conventional Commits, but we don't require to be `type(scope)` form by the way. The commit format should be

```gitcommit
<type/scope>: present/active tense short description, without ending marks
```

Supported types include:

- `ci` - GitLab CI-related stuff, CI scripts included
- `refractor` - Code refractoring
- `build` - Build scripts (hint: `.gitlab/ci/scripts/*-build`)
- `docs` - README, contributing guidelines, changelog
- `feat` - new features are implemented, in this case new packages/scripts/other stuff included in image
- `chore` - Business done outside of the source files
- `fix` - syntax issues, build failing, wrong package being installed, etc.

Supported scopes include, also supported if used as commit subject after type/scope:

- `ws-*`: changes related to one of workspace images, there are some exceptions such as:
  * `ws-base` - The base Debian/Ubuntu images for all things Gitpodified Workspace Images
  * `ws-full` - The bloddy 2+ GB workspace image (approx. 4 minutes to puil from GCP network as tested in GitLab Cloud Build in GitLab SaaS), including programming tools and stuff.[^3]
  * `ws-dotnet` - .NET Framework tooling, including LTS versions and VNC ones.

[^3]: All the blame goes to Rust packages compilied from source at install time on image size. Use Alpine instead.

If you ever include other chores/changes along side the headline change, you may also optionally use this format for these:

```gitcommit
Also in this commit:
* Some subject over here as placeholder
* Another text in here as another placeholder btw
* Assuming that we reached 100 characters on this line, we should cut this
  into an newline, like this.
```

### Changelog Entries

Each changelog entry should be itemized one-by-one, even before you commit and push your changes.

### Dockerfiles/Scripts

* Try to keep Hadolint/ShellCheck warnings and errors to an minimum. We ignored some issues, particularly the usage of sudo/doas,
unpinned dependencies in pip/npm/apk/etc, and bloody `SHELL ["/bin/sh", "-o", "pipefail"]` chaos on pipes.
* Fix syntax issues as much as possible. You don't want to take more than a day just to debug an EOF syntax issue, right?
* Its advised to test your images in production, we mean, in an fresh Gitpod workspace, [using this template repo](https://gitlab.com/gitpodify/bookish-potato)
before even submitting an MR.[^4]

[^4]: Currently, Gitpod doesn't support workspace rebuilds in a existing workspace yet like what Codespaces does.

## Local dev environment setup

While you can technically open this in an Remote Container in VS Code or in Gitpod, in case you just want your local development setup ready,
we document them below for your reference.

### Packages used

You need the following tools and packages to proceed. Since we're building with Dazzle v2 in second-half of Feburary 2022, the good old `docker-build` is being deprecated, so proceed at your own risk.

* Docker Engine/Desktop, but you're welcome to use Podman or other alternatives (hint: It should supports BuildKit via an env var similar
to `DOCKER_BUILDKIT=1` when using the `build` command)
  * You
* bash and coreutils
* Optional tools including direnv, ShellCheck and Hadolint.
* In case you are using Busybox-based distro or script break due to missing dependencies, make sure to install `bash`, GNU `coreutils` and `findutils`, and
`uuidgen` (sometimes called `uuid-runtime` in Debian/Ubuntu) packages from your distribution's repository or Homebrew.
