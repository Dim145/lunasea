---
title: Lidarr
parent: Notifications
grand_parent: LunaSea
nav_order: 1
---

# Lidarr

## Preparation

* Read through the main [Notifications](./) page
* Copy your device-based or user-based webhook URL from LunaSea

## Setup the Webhook

In Lidarr's web GUI, head to Settings -> Connect, hit the "+" button to add a new connection and select "Webhook". Please follow each section below to setup the webhook:

**Name**

Select any name, for example "LunaSea".

**Triggers**

Select which events should trigger a push notification. The following triggers are supported:

|         Trigger         | Supported? |
| :---------------------: | :--------: |
|         On Grab         |      ✅     |
|    On Release Import    |      ✅     |
|        On Upgrade       |      ✅     |
|   On Download Failure   |      ❌     |
|    On Import Failure    |      ❌     |
|        On Rename        |      ✅     |
|      On Track Retag     |      ✅     |
|  On Application Update  |      ❌     |
|     On Health Issue     |      ❌     |
| Include Health Warnings |      ❌     |

**Tags**

You can _**optionally**_ select a tag that must be attached to an artist for the webhook to get triggered.

This can be useful when working with a large media collection to only receive notifications for content you are actively monitoring.

If you want to receive notifications for all artists, leave the tags area empty.

**URL**

Paste the full device-based or user-based URL that was copied from LunaSea.

Each webhook can support a single user-based or device-based webhook URL. Attaching multiple device-based or user-based webhooks to a single Lidarr instance requires setting up multiple webhooks.

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

Once setup, close LunaSea and run the webhook test in Lidarr. You should receive a new notification letting you know that LunaSea is ready to receive Lidarr notifications!

## Example

An example Lidarr webhook can be seen below:

* No tags are set for this webhook, meaning all artists will trigger a notification.
* This is a user-based notification webhook, meaning it will be sent to all devices that are linked to the user ID `1234567890`.
* The webhook is associated with the profile named `My Profile`.

![](<../../.gitbook/assets/lidarr\_notification\_example (1).png>)
