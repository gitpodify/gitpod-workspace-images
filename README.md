# Gitpodified Workspace Images by Recap Time squad

[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod&style=for-the-badge)](https://gitpod.io/#https://gitlab.com/gitpodify/gitpodified-workspace-images) [![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.io/~gitpodify/repos/gitpodified-workspace-images)

The home of `quay.io/gitpod-workspace-images/*`/`docker.cloudsmith.io/~gitpodify/gitpodified-workspace-images/*` Docker images, maintained by @ajhalili2006 from @RecapTime. Merge requests are very welcome, through please take them all to upstream
`gitpod-io/workspace-images` repository on GitHub so we can rebase-then-merge them into here.

**NOTE TO USERS/CONTRIBUTORS**: ~~CI will be temporarily broken until the Dazzle v2 migration is finshed, so the ETA is maybe between Feb. 16 and March 2, Philippine Standard Time.~~ There is some progress on our Dazzle migration right now, but we'll still fixing the kinks and the edges on the build systems.

## Canonical Repo

The official canonical repo is on GitLab SaaS at <https://gitlab.com/gitpodify/gitpodified-workspace-images> while keeping the GitHub copy associated with the parent repo and in sync.

## Build Status / Available Images

Builds are always happens automagically on Red Hat Quay Container Registry from the `recaptime-dev-mainline` branch as we merge changes from the upstream. Click on an image name to get all available tags.

| Image Name | Description |
| --- | --- |
| [`quay.io/gitpodified-workspace-images/base`](https://quay.io/repository/gitpodified-workspace-images/base?tab=tags) | The base image for everything, with Zsh and OhMyZsh preloaded. |
| [`quay.io/gitpodified-workspace-images/full`](https://quay.io/repository/gitpodified-workspace-images/full?tab=tags) | The default Gitpod workspace image, plus additional tools such as Hadolint and ShellCheck. |
| [`quay.io/gitpodified-workspace-images/vnc`](https://quay.io/repository/gitpodified-workspace-images/vnc?tab=tags) | An flavor of `quay.io/gitpodified-workspace-images/full`, but with noVNC installed for graphical apps. |
| [`quay.io/gitpodified-workspace-images/postgresql`](https://quay.io/repository/gitpodified-workspace-images/postgresql?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/mysql`](https://quay.io/repository/gitpodified-workspace-images/mysql?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/mongodb`](https://quay.io/repository/gitpodified-workspace-images/mongodb?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/yugabytedb`](https://quay.io/repository/gitpodified-workspace-images/yugabytedb?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/node`](https://quay.io/repository/gitpodified-workspace-images/node?tab=tags) | Latest stable Node.js release with all the latest features before the next LTS. |
| [`quay.io/gitpodified-workspace-images/node-lts`](https://quay.io/repository/gitpodified-workspace-images/node-lts?tab=tags) | Latest stable Node.js release under LTS status. |
| [`quay.io/gitpodified-workspace-images/python`](https://quay.io/repository/gitpodified-workspace-images/python?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/ruby-2`](https://quay.io/repository/gitpodified-workspace-images/ruby-2?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/ruby-3`](https://quay.io/repository/gitpodified-workspace-images/ruby-3?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/go`](https://quay.io/repository/gitpodified-workspace-images/go?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/rust`](https://quay.io/repository/gitpodified-workspace-images/rust?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/dotnet-vnc`](https://quay.io/repository/gitpodified-workspace-images/dotnet-vnc?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/java-11`](https://quay.io/repository/gitpodified-workspace-images/java-11?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/java-17`](https://quay.io/repository/gitpodified-workspace-images/java-17?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/c`](https://quay.io/repository/gitpodified-workspace-images/c?tab=tags) | |
| [`quay.io/gitpodified-workspace-images/clojure`](https://quay.io/repository/gitpodified-workspace-images/clojure?tab=tags) | |

More images will be become available in the future, but you can build the images yourself if needed.

### Differences between ours from official workspace images

* Comes Zsh as default shell with OhMyZsh preloaded.
* UUID-related packages are included, plus ShellCheck, Hadolint and even Doppler CLI.
    * We don't forget GitHub CLI and GLab CLI if you prefer not to use the VSC extensions.
* ~~Provided `GITPODIFY_*` variables to help in community support and debugging purposes. (`docker inspect` our built images for `dev.gitpodify.*` labels)~~ Currently unsupported by current Dazzle setup, tracked at TBD
* Drop in user customizations to `~/.gitpodify/custom-zshrc.d` (don't forget to export `SOURCED_VIA_CUSTOM_ZSHRC` to any value to ensure
your OMZ customizations were not overrided by the defaults after doing the init yourself).
* **Coming soon:** Weekly rebuilds through GitHub Actions cronjobs to keep things fresh as possible.

## The Motivation and The Why

While Dazzle can help us in handling image caching, we want to ensure everything is fresh as possible and to keep the vulnerability count as low as possible in Quay image scans atleast for system packages
~~so we choose plain `docker build` built-in at Red Hat Quay Container Registry~~.

We initially use these images we built as drop-in replacement for the upstream images built through Dazzle, but sometimes outdated cache can cause different pain points for us.

## How to use?

* **In your `.gitpod.yml` file**: Just set `image` key to whatever the image that fits your case.

```yml
image: quay.io/gitpodified-workspace-images/full
```

* **On your custom workspace image Dockerfile**: Swap `gitpod/workspace-<type>` to `quay.io/gitpodified-workspace-images/<type>` as your base images.

```dockerfile
# Tip: Ignore DL3007 if using Hadolint since this is harmless, unless you want to lock version with
# dazzle-build-<timestamp> tags
FROM quay.io/gitpodified-workspace-images/full:latest

# If you use base as the starting point, then change repository to this:
FROM quay.io/gitpodified-workspace-images/base:latest
```

* **With Gitpodify CLI Alpha**: Run `gitpodify switch-ws-image quay.io/gitpodified-workspace-images/<type>` if you set it via the `.gitpod.yml` way. Otherwise, see previous method.[^1]

[^1]: The Gitpodify CLI is under prototype status and may be go into beta state within months. If you are curious, see <https://gitlab.com/gitpodify/gitpodify>

## Troubleshooting / FAQs

### Getting build metadata

Build metadata is stored in `~/.gitpodify/ws-image-metadata`, so you can copy its contents via `cat` so we can help debug issue faster.

### Debian/Ubuntu only?

We want to also support RHEL and Alpine in the future, but that would be an additional workload for the maintainers, which is currently one man, so sorry.

### But why Quay.io? Why not using the GitLab Container Registry SaaS at `registry.gitlab.com`?

Mostly because of the default storage limits. Technically, @ajhalili2006 also can't afford paying a few bucks (hundreds to thousands of PHP when converted).

We avoided Docker Hub as much as possible so you don't worry about pull limits on per-IP address or per-user basis.

### When migrating to Dazzle v2?

~~We're currently slowly migrating to Dazzle v2 right now. Metadata stuff will then be added next very soon.~~ We're done migrating to Dazzle v2, so we'll start synchorizing our fork against the upstream to keep things up-to-date as much as possible.
