---
title: Custom Notifications
parent: Notifications
grand_parent: LunaSea
nav_order: 6
---

# Custom Notifications

## Preparation

> Custom notifications are considered an advanced feature, and requires basic knowledge of JSON syntax and creating your own scripts/tools to handle sending the payloads.
{: .warning }

* Read through the main [Notifications](./) page
* Copy any module's device-based or user-based webhook URL from LunaSea

You will need to slightly modify the webhook URL you have copied from any of the modules. Simply replace the name of the module within the webhook URL to `custom` and you're good to go!

Alternatively, you can copy the content of the URL after the last slash (after `device/` or `user/`) to obtain your Firebase device or user identifier.

## Endpoints

Custom notifications are supported by both device-based and user-based notifications, with full endpoint details below:

`POST https://notify.lunasea.app/v1/custom/device/:device_id` — Device-Based

Send a custom notification using a device token to a single device running LunaSea.

**Parameters**

- `device_id` (string, in path) _(required)_ — The Firebase device identifier
- `title` (string, in body) _(required)_ — The notification's title.
- `body` (string, in body) _(required)_ — The notification's body content.
- `image` (string, in body) — A

**publicly accessible**

URL to an image that will be attached to the notification.

**Responses**

- `200`

  ```
  ```javascript
{
    "status": "OK"
}
```
  ```
- `500`

  ```
  ```javascript
{
    "status": "Internal Server Error"
}
```
  ```


`POST https://notify.lunasea.app/v1/custom/user/:user_id` — User-Based

Send a custom notification using a user token to all devices signed into that LunaSea account.

**Parameters**

- `user_id` (string, in path) _(required)_ — The Firebase user identifier
- `title` (string, in body) _(required)_ — The notification's title.
- `body` (string, in body) _(required)_ — The notification's body content.
- `image` (string, in body) — A

**publicly accessible**

URL to an image that will be attached to the notification.

**Responses**

- `200`

  ```
  ```javascript
{
    "status": "OK"
}
```
  ```
- `400`

  ```
  ```javascript
{
    "status": "No devices found"
}
```
  ```
- `404`

  ```
  ```javascript
{
    "status": "Invalid User ID"
}
```
  ```
- `500`

  ```
  ```javascript
{
    "status": "Internal Server Error"
}
```
  ```


## Troubleshooting

* Ensure that the required `title` parameter is a string type.
  * If the type is not a string, the notification will fail.
  * Sending no value or a null value will result in the title "Unknown Title" being used.
* Ensure that the required `body` parameter is a string type.
  * If the type is not a string, the notification will fail.
  * Sending no value or a null value will result in the body "Unknown Content" being used.
* If sending an image, ensure that the content is a valid URL.
  * If the content is not a valid URL, the notification will fail.
  * The URL must contain the protocol, `http://` or `https://`.
  * The URL must be a direct link to the image and does not redirect.
  * The URL must be publicly accessible, not requiring any authentication to access.
* If sending an image, the image must be a supported image type.
  * Supported types include JPGs, PNGs, and animated GIFs.
