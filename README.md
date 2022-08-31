# httpdCAS

Adds mod_auth_cas to the official Apache container on Docker Hub ([httpd](https://hub.docker.com/_/httpd)).

This repository is mirrored to GitHub at [https://github.com/eitumd/httpd-cas](https://github.com/eitumd/httpd-cas).

## How to use

1. Bind or volume mount a custom `httpd-vhosts.conf` file to `/usr/local/apache2/conf/extra/httpd-vhosts.conf` to configure virtual hosts.
2. Bind or volume mount your `DocumentRoot` to `/usr/local/apache2/htdocs` on the container.
3. The `mod_proxy` & `mod_proxy_http` modules are enabled by default & can be used to configure `ProxyPass` directives in your virtual host configuration.

### Sample docker-compose

```
version: '3.9'
services:
  httpd:
    image: registry.code.umd.edu/eit/development/saas/httpd-cas/httpd:latest
    restart: always
    ports:
      - 8080:80
    volumes:
      - ./path/to/vhosts.conf:/usr/local/apache2/conf/extra/httpd-vhosts.conf
      - ./path/to/files:/usr/local/apache2/htdocs
```

### Protecting things with CAS

To protect something with CAS, you can add something like the below to a virtual host configuration.

```
<Location "/">
    AuthType CAS
    AuthName "UMD CAS"
    Require valid-user
</Location>
```

If you want to protect an app but exclude a particular URL path (for an API, as an example), this works well.

```
<Location "/">
    AuthType CAS
    SetEnvIf Request_URI /api noauth=1
    AuthName "UMD CAS"
    <RequireAny>
        Require env noauth
        Require env REDIRECT_noauth
        Require valid-user
    </RequireAny>
</Location>
```

If you're using this container in front of an application to auth users, you'll want this config, specifically note the `CASAuthNHeader` value. This adds the REMOTE_USER variable as a HTTP header in addition to the env variable that mod_auth_cas sets by default. Since we can't share environment variables between containers, HTTP headers are the way to go. Also ensure you set `CASRootProxiedAs` with the public service URI if this container is sitting in front of another container. If you don't do this, the mod_auth_cas module attempts to build the URL based on the VirtualHost configuration (which may be incorrect if proxied).

```
CASRootProxiedAs https://service.umd.edu
<Location "/">
    AuthType CAS
    SetEnvIf Request_URI /api noauth=1
    AuthName "UMD CAS"
    <RequireAny>
        Require env noauth
        Require env REDIRECT_noauth
        Require valid-user
    </RequireAny>
    CASAuthNHeader REMOTE_USER
</Location>
```

## Configuration

### Static Files

You can map static files in using a docker volume or bind mounts to `/usr/local/apache2/htdocs` on the container.

### Modules

In addition to the modules Apache loads by default, we also load:

* mod_proxy
* mod_proxy_http
* mod_rewrite
* mod_auth_cas

### Defaults

We set the following config values by default in httpd.conf:

* `CASCookiePath` to `/var/cache/apache2/mod_auth_cas/`
* `CASLoginURL` to `https://shib.idm.umd.edu/shibboleth-idp/profile/cas/login`
* `CASValidateURL` to `https://shib.idm.umd.edu/shibboleth-idp/profile/cas/serviceValidate`

### Custom Configuration

We recommend the same method the upstream project uses to add a custom configuration to this container.

First obtain the default configuration from the container:

`$ docker run --rm registry.code.umd.edu/eit/development/saas/httpd-cas/httpd:latest cat /usr/local/apache2/conf/httpd.conf > my-httpd.conf`

You can then COPY your custom configuration in as /usr/local/apache2/conf/httpd.conf in a new custom container (Dockerfile):

```
FROM registry.code.umd.edu/eit/development/saas/httpd-cas/httpd:latest
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
```
