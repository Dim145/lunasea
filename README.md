# <img width="40px" src="./lunasea/assets/images/branding_logo.png" alt="LunaSea"></img>&nbsp;&nbsp;LunaSea

> Self-hosted controller for your media server stack. This mono-repository
> hosts every component of the LunaSea project.

## Components

| Path | What it is |
| :--- | :--- |
| [`lunasea/`](lunasea/) | The Flutter app (Android / iOS / macOS / Linux / Windows / Web). |
| [`lunasea-notification-service/`](lunasea-notification-service/) | The Node.js backend that receives webhooks from the *arr stack and forwards them as push notifications. |
| [`lunasea-cloud-functions/`](lunasea-cloud-functions/) | Firebase functions used by the original hosted setup (kept for reference). |
| [`lunasea-docs/`](docs/) | User-facing GitBook documentation. |

## Releases

Docker images are built and published to this repository's [GitHub Container Registry](https://github.com/features/packages) on each GitHub Release. See [`.github/workflows/build-docker.yml`](.github/workflows/build-docker.yml).
