# Gitpod Workspace Images

[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod&style=for-the-badge)](https://gitpod.io/#https://gitlab.com/gitpodify/gitpodified-workspace-images)

The home of `quay.io/gitpod-workspace-images/*` Docker images, maintained by @ajhalili2006. Merge requests are very welcome, through please take them all to upstream `gitpod-io/workspace-images` so we can pull them into here.

## Canonical Repo

The official canonical repo is on GitLab SaaS at <https://gitlab.com/gitpodify/gitpodified-workspace-images> while keeping the GitHub copy associated with the parent repo and in sync.

## Build Status / Available Images

Builds are always happens automagically on Red Hat Quay Container Registry from the `recaptime-dev-mainline` branch as we merge changes from the upstream. Click on an image name to get all available tags.

| Image Name | Description | RHQCR/CI Badge |
| --- | --- | --- |
| [`quay.io/gitpodified-workspace-images/base`](https://quay.io/repository/gitpodified-workspace-images/base?tab=tags) | The base image for everything. | [![Docker Repository on Quay](https://quay.io/repository/gitpodified-workspace-images/base/status "Docker Repository on Quay")](https://quay.io/repository/gitpodified-workspace-images/base) |
| [`quay.io/gitpodified-workspace-images/full`](https://quay.io/repository/gitpodified-workspace-images/full?tab=tags) | The default Gitpod workspace image, plus additional tools such as Hadolint and ShellCheck. | TBD |
| [`quay.io/gitpodified-workspace-images/vnc`](https://quay.io/repository/gitpodified-workspace-images/vnc?tab=tags) | An flavor of `quay.io/gitpodified-workspace-images/full`, but with noVNC installed for graphical apps. | TBD |

More images will be become availabe in the future, but you can build the images yourself if needed.

## The Motivation and The Why

While Dazzle can help us in handling image caching, we want to ensure everything is fresh as possible and to keep the vunlearbility count as low as possible in Quay image scans, so we choose plain `docker build` built-in at Red Hat Quay Container Registry.

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
