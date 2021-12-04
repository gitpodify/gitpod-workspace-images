# Gitpodified Workspace Images by Recap Time squad

[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod&style=for-the-badge)](https://gitpod.io/#https://gitlab.com/gitpodify/gitpodified-workspace-images)

The home of `quay.io/gitpod-workspace-images/*` Docker images, maintained by @ajhalili2006 from @RecapTime. Merge requests are very welcome, through please take them all to upstream 
`gitpod-io/workspace-images` repository on GitHub so we can rebase-then-merge them into here.

## Canonical Repo

The official canonical repo is on GitLab SaaS at <https://gitlab.com/gitpodify/gitpodified-workspace-images> while keeping the GitHub copy associated with the parent repo and in sync.

## Build Status / Available Images

Builds are always happens automagically on Red Hat Quay Container Registry from the `recaptime-dev-mainline` branch as we merge changes from the upstream. Click on an image name to get all available tags.

| Image Name | Description | RHQCR/CI Badge |
| --- | --- | --- |
| [`quay.io/gitpodified-workspace-images/base`](https://quay.io/repository/gitpodified-workspace-images/base?tab=tags) | The base image for everything. | [![Docker Repository on Quay](https://quay.io/repository/gitpodified-workspace-images/base/status "Docker Repository on Quay")](https://quay.io/repository/gitpodified-workspace-images/base) |
| [`quay.io/gitpodified-workspace-images/full`](https://quay.io/repository/gitpodified-workspace-images/full?tab=tags) | The default Gitpod workspace image, plus additional tools such as Hadolint and ShellCheck. | [![Docker Repository on Quay](https://quay.io/repository/gitpodified-workspace-images/full/status "Docker Repository on Quay")](https://quay.io/repository/gitpodified-workspace-images/full) |
| [`quay.io/gitpodified-workspace-images/vnc`](https://quay.io/repository/gitpodified-workspace-images/vnc?tab=tags) | An flavor of `quay.io/gitpodified-workspace-images/full`, but with noVNC installed for graphical apps. | TBD |

More images will be become available in the future, but you can build the images yourself if needed.

## The Motivation and The Why

While Dazzle can help us in handling image caching, we want to ensure everything is fresh as possible and to keep the vulnerability count as low as possible in Quay image scans, so we choose plain `docker build` built-in at Red Hat Quay Container Registry.

We initially use these images we built as drop-in replacement for the upstream images built through Dazzle, but sometimes outdated cache can cause different pain points for us.

## How to use?

* **In your `.gitpod.yml` file**: Just set `image` key to whatever the image that fits your case.

```yml
image: quay.io/gitpodified-workspace-images/full
```

* **On your custom workspace image Dockerfile**: Swap `gitpod/workspace-<type>` to `quay.io/gitpodified-workspace-images/<type>` as your base images.

```dockerfile
# Tip: Ignore DL3007 if using Hadolint since this is harmless, unless you want to lock version with
# build-<commit sha> tags
FROM quay.io/gitpodified-workspace-images/full:latest

# If you use base as the starting point, then change repository to this:
FROM quay.io/gitpodified-workspace-images/base:latest
```

* **With Gitpodify CLI Alpha**: Run `gitpodify switch-ws-image quay.io/gitpodified-workspace-images/<type>` if you set it via the `.gitpod.yml` way. Otherwise, see previous method.[^1]

[^1]: The Gitpodify CLI is under prototype status and may be go into beta state within months. If you are curious, see <https://gitlab.com/gitpodify/gitpodify>
## Troubleshooting / FAQs

### Having issues with Let's Encrypt or other TLS certs?

You may have outdated version of `ca-certificated` package installed. Try running the `upgrade-packages` script provided in the images with `sudo`. If you're sadly on the official images, try running this:

```bash
# Note that upgrades are only valid for duration of your workspace session unless you add it to your .gitpod.Dockerfile.
curl -fsSL https://github.com/gitpodify/gitpod-workspace-images/raw/master/base/upgrade-packages | sudo bash -
```

When using one of our images, this should fix the problem at least. If you have an self-signed one, make sure to add them through your `.gitpod.Dockerfile` as needed.

### Debian/Ubuntu only?

We want to also support RHEL and Alpine in the future, but that would be an additional workload for the maintainers, which is currently one man, so sorry.

### But why Quay.io? Why not using the GitLab Container Registry SaaS at `registry.gitlab.com`?

Mostly because of the default storage limits. Technically, @ajhalili2006 also can't afford paying a few bucks (hundreds to thousands of PHP when converted).

We avoided Docker Hub as much as possible so you don't worry about pull limits on per-IP address or per-user basis.

### When migrating to Dazzle v2?

We're not sure if we're gonna use Dazzle v2 on build stages and on localdev/Gitpod. We'll let you know soon.
