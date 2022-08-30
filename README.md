# nginxCAS

Adds CAS support to nginx, similar to Apache's mod_auth_cas.

## Parameters

| Parameter |	Description |
| --------- | ----------- |
| `-e TZ=UTC`	| Timezone. |
| `-p 8080:80` | Expose Nginx on localhost:8080. |
| `-v /local/path/to/website:/var/www/html` |	Mount and serve a local website. |
| `-v /path/to/conf.template:/etc/nginx/templates/conf.template` |	Mount template files inside /etc/nginx/templates. They will be processed and the results will be placed at /etc/nginx/conf.d. (e.g. listen ${NGINX_PORT}; will generate listen 80;). |
| `-v /path/to/nginx.conf:/etc/nginx/nginx.conf` |	Local configuration file nginx.conf (try this example). |

# Configuration

* Configuration needed in global nginx config (mapped in per project usually)

```
# needed for resty.http
resolver 8.8.8.8;
lua_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;

lua_package_path '/etc/nginx/lua/?.lua;;';
lua_shared_dict cas_store 10M;
```

* protect a location (REMOTE_USER is passed to proxy implicitly):

```
location /secured {
    access_by_lua_block { require('cas').forceAuthentication() }
    proxy_pass ...;
    ...
}
```

NB: `access_by_lua_block` must be *before* proxy_pass

* or for FASTCGI protect a location and provide REMOTE_USER explicitly:
  ```
  location /secured {
    access_by_lua_block { require('cas').forceAuthentication() }
    fastcgi_pass ...;
    fastcgi_param REMOTE_USER $http_remote_user;
    ...
  }
  ```


# Known limitations

* only CAS protocol v2
* no CAS proxy
* no CAS single sign out

# Various information

* this work is based on [Toshi Piazza's ngx-http-cas-client-lua](https://github.com/toshipiazza/ngx-http-cas-client-lua)
* we could be using [ngx.location.capture](https://github.com/openresty/lua-nginx-module#ngxlocationcapture), but it [does not work with HTTP/2](https://github.com/openresty/lua-nginx-module/issues/1195#issuecomment-346410275).
* with apache mod_auth_cas, you can not protect both in apache and in backend: mod_auth_cas will always validate the ticket, even if its session is valid. The current nginx-auth-cas-lua code does not have this limitation. NB: if the backend ask for proxy tickets, either use a different url to receive `pgtIou`, or use 
```nginx
if ($remote_addr !~ "^192[.]168[.]1[.](56|57)$") { # if request is from CAS, let it go to the backend unauthenticated (needed for pgtIOU)
    access_by_lua_block { require('cas').forceAuthentication() }
}
```
