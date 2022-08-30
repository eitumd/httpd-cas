FROM openresty/openresty:buster-fat

# Install dependencies
RUN apt-get update
RUN apt-get install wget -y
RUN mkdir -p /usr/local/openresty/lualib/resty
RUN cd /usr/local/openresty/lualib/resty
RUN wget https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lib/resty/http_headers.lua
RUN wget https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lib/resty/http_connect.lua
RUN wget https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lib/resty/http.lua

# Install nginx-auth-cas-lua
RUN cd /usr/local/openresty/lualib
RUN wget https://raw.githubusercontent.com/prigaux/nginx-auth-cas-lua/master/src/cas.lua
RUN wget https://raw.githubusercontent.com/prigaux/nginx-auth-cas-lua/master/src/global_cas_conf.lua

# Configure cas_uri for UMD CAS
RUN sed -i 's+https://cas.univ.fr/cas+https://shib.idm.umd.edu/shibboleth-idp/profile/cas+g' global_cas_conf.lua
RUN cat global_cas_conf.lua
