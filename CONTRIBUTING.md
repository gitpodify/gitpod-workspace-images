# Contributing Guidelines/Docs

First, we recommend bringing your improvements and feature requests to [the upstream](https://github.com/gitpod-io/workspace-images/blob/master/CONTRIBUTING.md) as we'll sync upstream changes with ours.
The rest of this documentation applies to this fork only.

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

These guidelines are not strict rules, other than the commit messages. Some stuff are an work in progress right now in this section, especially on the changelog side. Consider this section as more of
best pratices than rules here.

### Commit Messages

It's some form of Conventional Commits/Changelog, but we don't require to be `type(scope)` form by the way. The commit format should be

```gitcommit
<type/scope>: present/active tense short description, without ending marks

# if going to the regular route
<type(scope)>: present/active tense short description, without ending marks
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
  - `ws-base` - The base Debian/Ubuntu images for all things Gitpodified Workspace Images
  - `ws-full` - The bloddy 2+ GB workspace image (approx. 4 minutes to puil from GCP network as tested in GitLab Cloud Build in GitLab SaaS), including programming tools and stuff.[^3]
  - `ws-dotnet` - .NET Framework tooling, including LTS versions and VNC ones.
- `gitlab-cicd` - Scripts and CI config for GitLab CI
- `global` - Changes tht affect everything, shouldn't used on regular basis unles pulling upstream changes and merging contributions

[^3]: All the blame goes to Rust packages compilied from source at install time on image size.

If you ever include other chores/changes along side the headline change, you may also optionally use this format for these:

```gitcommit
# list type
Also in this commit:
* Some subject over here as placeholder
* Another text in here as another placeholder btw
* Assuming that we reached 100 characters on this line, we should cut this
  into an newline, like this.

# sentence type
Also in this commit, we explain how the sentence typically work while cutting
stuff to ensure each line don't reach the 100 character limit by Commitlint in
the future.
```

### Changelog Entries

Each changelog entry should be itemized one-by-one, even before you commit and push your changes. If you
ever commit your stuff, the commit format should be like this:

```gitcommit
docs(changelog): update changelog entries for unreleased

# YOUR SIGNOFF GOES HERE IN FORM OF THIS FORMAT, GENERATED VIA --signoff flag ON
# THE git-commit COMMAND
Signed-off-by: Your Name <user@email.tld>
```

### Dockerfiles/Scripts

- Try to keep Hadolint/ShellCheck warnings and errors to an minimum. We ignored some issues, particularly the usage of sudo/doas,
unpinned dependencies in pip/npm/apk/etc, and bloody `SHELL ["/bin/sh", "-o", "pipefail"]` chaos on pipes.
- Fix syntax issues as much as possible. You don't want to take more than a day just to debug an EOF syntax issue, right?
- Its advised to test your images in production, we mean, in an fresh Gitpod workspace, [using this template repo](https://gitlab.com/gitpodify/bookish-potato).
before even submitting an MR.[^4]
- Since our base image is based on Ubuntu, third-party repository best pratices specific to Debian/Ubuntu also applies here.
- Make sure non-root users (aka `gitpod` user) on the container can access the installed tool/lang.
- The last `USER` directive **SHOULD** always be `gitpod` **NOT** the root user.
- **DO NOT** update the `~/.bashrc` or `~/.zshrc` files unless you are making change in the base layer or on tool-specific Dockerfile layer.

### Dazzle-specifics

- Always add new path as prefix to existing path. e.g. `ENV PATH=/my-tool/path/bin:$PATH`. Not doing so can cause path conflicts and can potentially break other images.
- When adding an combination to `dazzle.yaml`, use an meaningful name

[^4]: Currently, Gitpod doesn't support workspace rebuilds in a existing workspace yet like what Codespaces does. In meanwhile, feel free to create a fresh workspace if needed.

## Required Tools

Even through they're included in [an custom Gitpod workspace Dockerfile](.gitpod.Dockerfile) for this repository and start them automagically ([config here for reference](.gitpod.yml))
when you repo this repo in Gitpod, you may also opt to do this locally or outside Gitpod.

Other than [the Docker CLI and Docker CE deamon, an local registry, Dazzle and the main Buildkit CLI itself][sauce-1], you also need:

* Optional tools including direnv, ShellCheck and Hadolint.
* In case you are using Busybox-based distro or script break due to missing dependencies, make sure to install `bash`, GNU `coreutils` and `findutils`

[sauce-1]: https://github.com/gitpod-io/workspace-images/blob/master/CONTRIBUTING.md#tools

Note that an local registry setup is omitted in CI process and just straight to our artifact repositories in GHCR, since we do `docker login` process.

## Building Images

### local.dev

The upstream shipped an script in the root of the repository to simply the process for you, but we modified it to support overriding it.

To get started, run it in an shell session:

```bash
./build-all.sh

# Use an remote cache, but since Dazzle needs to push builds to the registry we assume you have enough
# permissions to do so. Also, do not use the example value of IMAGE_ARTIFACTS_REPO below.
REPO=ghcr.io/gitpodify/gitpodified-workspace-images/dazzle-build-artifact ./dazzle-up.sh
```

This script will first build the chunks and run tests followed by creation of container images. It uses dazzle to perform these tasks.

The images will be pushed to the local registry server running on port 5000 by default unless `IMAGE_ARTIFACTS_REPO` is set. You can pull the images using the regular `docker pull` command.

```bash
# combo - one of the image combinations listed in dazzle.yaml config file at repo root
# Note that if you authenticate with your registry of choice and override the REPO var in the script
# make sure to change localhost:5000/recaptime-dev/gp-ws-images-build-artifacts too.
docker pull localhost:5000/recaptime-dev/gp-ws-images-build-artifacts:combo
```

Building images locally consumes a lot of resources and is often slow. Depending on your internet speeds, the amount of RAM and CPU cores you have, it might take 1.25 hours or longer to build the
images locally. Subsequent builds are faster if the number of modified chunks is less, assuming no significant
changes were happened.

### Build Specific Chunks

Often, you would want to test only the chunks that you modify. You can do that with build-chunk.sh using the `-c` flag.

```console
./build-chunk.sh -c lang-c -c dep-cacert-update -c lang-go:1.17.5
```

Above command will build only chunks `lang-c` and `dep-cacert-update`.

The next step, is to test your changes with [./build-combo](#build-specific-combination).

### Build Specific Combination

Sometimes you only want to build one specific combination e.g. the `postgresql` or the `go` image. You can do that with

```console
./build-combo.sh <comboName> e.g. ./build-combo.sh postgresql
```

This will build all chunks that are referenced by the `go` combination and then combine them to create the `go` image.


## CI/CD

We're using upstream's GitHub Actions configuration files with some customizations for our side. We're still using GitLab CI for toher things such as linting stuff through `pre-commit` and other things.

<details>

<summary>Older info for our GitLab CI usage for Dazzle</summary>

We use GitLab CI for our pipelines, running on GitLab SaaS' public runners at GCP. All of our configuration are in the `.gitlab/ci` directory, while scripts for the CI is at the `scripts` subdirectory.

Even through GitLab's public runners are less powerful than GitHub's public runners for GH Actions
due to cost-saving reasons, these are being built inside an Docker container.

</details>

### Build

~~Currently builds happens on `recaptime-dev-mainline` and no caching due to the 10G default project storage limit
in GitLab SaaS.~~ We use GitHub Container Registry for caching Dazzle builds and stuff, and then sync them manually to Quay.io.

## Contributing an new image

Remember to ALWAYS submit your images to the upstream and follow upstream's contribution workflow instead.
If you think this image is better to be fit here than in upstream, read on.

A chunk is categorized broadly in two categories:

- **lang** - A language chunk such as java, clojure, python etc.
- **tool** - A tool chunk such as nginx, vnc, postgresql etc.

A chunk should be named following the naming convention `category-name`. e.g. a java chunk would be named as `lang-java` whereas
a `postgresql` chunk would be named `tool-postgresql`.

To get started, run `dazzle project init <category-name>` to automagically update the configuration and create
files for you. If you need to manually do it, here's the checklist:

- [ ] Create your chunk directory under [./chunks](chunks)
- [ ] Create a `chunk.yaml` file if your chunk has more than one active versions.
You can look at the existing files in this repo for reference e.g. [lang-java](chunks/lang-java/chunk.yaml).
- [ ] Create a Dockerfile containing instructions on how to install the tool. Make sure you use the default base image like other chunks, like this one below.

  ```dockerfile
  # Dazzle needs to ensure that each chunk is built based on the base image, so we explictly import
  # the base build argument for the FROM directive.
  ARG base
  FROM ${base}
  ```

- [ ] Lint your Dockerfile against Hadolint and fix as much as possible. If there's no available good rewrite/fixes, ignore it using `#hadolint ignore=` directive on the top.
