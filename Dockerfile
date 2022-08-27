FROM ubuntu/nginx:1.18-20.04_beta

# Install dependencies
RUN apt-get update
RUN apt-get install libnginx-mod-http-lua -y
RUN mkdir -p /etc/nginx/lua/resty
RUN cd /etc/nginx/lua/resty/
RUN wget https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lib/resty/http_headers.lua
RUN wget https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lib/resty/http_connect.lua
RUN wget https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lib/resty/http.lua

# Install nginx-auth-cas-lua
RUN cd /etc/nginx/lua/
RUN wget https://raw.githubusercontent.com/prigaux/nginx-auth-cas-lua/master/src/cas.lua
RUN wget https://raw.githubusercontent.com/prigaux/nginx-auth-cas-lua/master/src/global_cas_conf.lua
