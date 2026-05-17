---
title: Radarr
parent: Notifications
grand_parent: LunaSea
nav_order: 2
---

# Radarr

## Preparation

* Read through the main [Notifications](./) page
* Copy your device-based or user-based webhook URL from LunaSea

## Setup the Webhook

In Radarr's web GUI, head to Settings -> Connect, hit the "+" button to add a new connection and select "Webhook". Please follow each section below to setup the webhook:

**Name**

Select any name, for example "LunaSea".

**Triggers**

Select which events should trigger a push notification. The following triggers are supported:

|              Trigger             | Supported? |
| :------------------------------: | :--------: |
|              On Grab             |      ✅     |
|             On Import            |      ✅     |
|            On Upgrade            |      ✅     |
|             On Rename            |      ✅     |
|          On Movie Delete         |      ❌     |
|       On Movie File Delete       |      ❌     |
| On Movie File Delete For Upgrade |      ❌     |
|          On Health Issue         |      ✅     |
|      Include Health Warnings     |      ✅     |
|       On Application Update      |      ❌     |

**Tags**

You can _**optionally**_ select a tag that must be attached to a movie for the webhook to get triggered.

This can be useful when working with a large media collection to only receive notifications for content you are actively monitoring.

If you want to receive notifications for all movies, leave the tags area empty.

**URL**

Paste the full device-based or user-based URL that was copied from LunaSea.

Each webhook can support a single user-based or device-based webhook URL. Attaching multiple device-based or user-based webhooks to a single Radarr instance requires setting up multiple webhooks.

**Method**

Keep the method on "**POST**". Changing the method to "**PUT**" will cause the webhooks to fail.

**Username**

The username field should be an **exact match** to the profile that this module instance was added to within LunaSea. Capitalization and punctuation _does_ matter.

> This step is only required if you are _**not**_ using the default LunaSea profile (`default`). LunaSea will assume the default profile when none is supplied.
>
> Correctly setting up this field is critically important to get full deep-linking support.
{: .warning }

**Password**

Leave the password field empty. Setting this field will currently have no effect.

Once setup, close LunaSea and run the webhook test in Radarr. You should receive a new notification letting you know that LunaSea is ready to receive Radarr notifications!

## Example

An example Radarr webhook can be seen below:

* No tags are set for this webhook, meaning all movies will trigger a notification.
* This is a user-based notification webhook, meaning it will be sent to all devices that are linked to the user ID `1234567890`.
* The webhook is associated with the profile named `My Profile`.

![](../../.gitbook/assets/radarr\_notification\_example.png)
