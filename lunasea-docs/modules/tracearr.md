# Tracearr

[Tracearr](https://tracearr.com) is a unified monitoring platform for **Plex, Jellyfin and Emby** servers. Unlike Tautulli (Plex-only), Tracearr consolidates all three media servers into a single dashboard with real-time stream tracking, playback analytics, watch history, and account-sharing detection.

The LunaSea Tracearr module exposes the most useful pieces of Tracearr's public API directly in the app.

## Features

| Tab | Capabilities |
| :--- | :--- |
| **Streams** | Live list of active playback sessions across every server (Plex / Jellyfin / Emby). Auto-refresh every 15 seconds, pull to refresh, summary bar (total / direct / transcode / bandwidth), per-stream progress bar colored by playback state (playing / paused / stopped). |
| **History** | Paginated session history. Each entry shows the user, server, codec, resolution, transcode badge, and a "watched" indicator (≥ 85 % completion). |
| **Users** | One row per `user × server`. Trust score (0-100) coloured red / orange / green, role, session count, violation count. |
| **Violations** | Account-sharing detections. Severity icon and colour reflect `low` / `warning` / `high`. |

Tapping any item opens a detail page:

- **Stream details** — full Metadata / Player / Stream breakdown plus a **Terminate Session** button at the bottom that lets you optionally type a message shown to the user before kicking them.
- **History details** — Metadata / Session / Player blocks, including the paused-time delta and segment count for sessions that were resumed.
- **User details** — Profile and Stats blocks (sessions, trust score, violations, member since, last active relative time).

## Setup

You'll need a self-hosted Tracearr instance with at least one media server connected. See the [Tracearr docs](https://docs.tracearr.com/getting-started/first-server) for the server setup.

1. In Tracearr, open **Settings → General** and **generate an API key**. Tracearr issues tokens prefixed with `trr_pub_…`.
2. In LunaSea, go to **Settings → Configuration → Tracearr**.
3. Toggle **Enable Module** on.
4. Fill in:
   - **Host** — the base URL of your Tracearr instance (`https://tracearr.example.com`, no trailing slash needed).
   - **API Key** — the `trr_pub_…` token from step 1.
5. The module now appears in the LunaSea drawer with a teal "travel explore" icon.

### CORS (Web only)

If you run the **LunaSea Web** build against a self-hosted Tracearr, the browser enforces same-origin checks on the API calls. By default Tracearr only allows its own frontend's origin. Set the `CORS_ORIGIN` env var on your Tracearr container to the LunaSea Web origin (e.g. `https://lunasea.example.com`), or leave it empty to allow all origins (reflects the request origin). The native LunaSea apps (Android / iOS / desktop) are not affected.

## Notifications

Tracearr emits **Discord-shaped webhooks** when its rule engine fires (e.g. account sharing detected). That format isn't compatible with the `lunasea-notification-service` schema today, so push notifications **from Tracearr** through LunaSea's notification pipeline are not yet supported. The other tabs (streams / history / users / violations) work fine without notifications enabled.

## Platform support

| Platform | Supported? |
| :------: | :--------: |
|  Android |      ✅     |
|    iOS   |      ✅     |
|   Linux  |      ✅     |
|   macOS  |      ✅     |
|  Windows |      ✅     |
|    Web   |    ✅ \*     |

\* Web is supported but requires Tracearr's `CORS_ORIGIN` to allow the LunaSea Web origin (see [Setup](#setup)).
