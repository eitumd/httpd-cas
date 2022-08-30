FROM httpd:2.4

## Install build dependencies
RUN apt-get update \
    && apt-get install -y wget dh-autoreconf libapr1-dev libaprutil1-dev libssl-dev libcurl4-openssl-dev libpcre3-dev build-essential

## Download CAS module & configure
WORKDIR /
RUN wget https://github.com/apereo/mod_auth_cas/archive/refs/tags/v1.2.tar.gz \
    && tar -xvzf v1.2.tar.gz
RUN pwd && ls
RUN cd /mod_auth_cas-1.2 \
    && autoreconf -iv \
    && ./configure --with-apxs=/usr/local/apache2/bin/apxs \
    && make \
    && make install

## Uncomment httpd-vhosts.conf in extras to enable custom vhost support
RUN sed -i '/httpd-vhosts.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

## Load modules
RUN echo "LoadModule proxy_module /usr/local/apache2/modules/mod_proxy.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule proxy_http_module /usr/local/apache2/modules/mod_proxy_http.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule rewrite_module /usr/local/apache2/modules/mod_rewrite.so" >> /usr/local/apache2/conf/httpd.conf
