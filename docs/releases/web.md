# Web

LunaSea can be hosted as a web application for usage within any modern browser!

{% hint style="info" %}
If you want a stable experience, stick with stable releases. Want to test new builds of LunaSea? Read about the [build channels](https://docs.lunasea.app/getting-started/build-channels) to make the right choice!
{% endhint %}

## Hosted Builds

_Channel(s): `Stable`, `Beta`, `Edge`_

All web releases of LunaSea are available on hosted instances by the LunaSea team! All communication and data stored is client-side, but there are some limitations of the platform which can be [viewed here](https://docs.lunasea.app/getting-started/platform-restrictions).

{% tabs %}
{% tab title="Stable" %}
Access the stable release [here](https://web.lunasea.app/)!
{% endtab %}

{% tab title="Beta" %}
Access the beta release [here](https://beta.web.lunasea.app/)!
{% endtab %}

{% tab title="Edge" %}
Access the edge release [here](https://edge.web.lunasea.app/)!
{% endtab %}
{% endtabs %}

## Docker

_Channel(s): `Stable`, `Beta`, `Edge`_

All web releases of LunaSea are also available in officially hosted Docker images! There is currently only one value that needs to be configured which is the port mapping. LunaSea functions as a frontend application with all data being stored client-side.

{% tabs %}
{% tab title="Stable" %}
```
docker run -p 80:80 ghcr.io/jagandeepbrar/lunasea:stable
```
{% endtab %}

{% tab title="Beta" %}
```
docker run -p 80:80 ghcr.io/jagandeepbrar/lunasea:beta
```
{% endtab %}

{% tab title="Edge" %}
```
docker run -p 80:80 ghcr.io/jagandeepbrar/lunasea:edge
```
{% endtab %}
{% endtabs %}

## Build Bucket

_Channel(s): `Stable`, `Beta`, `Edge`_\
_Format(s): `.zip`_

All web releases are available in the [Build Bucket](https://builds.lunasea.app/#latest/)!

## GitHub Releases

_Channel(s): `Stable`_\
_Format(s): `.zip`_

All stable releases are available on GitHub via the [Releases](https://github.com/JagandeepBrar/LunaSea/releases) page!
