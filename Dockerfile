FROM httpd:2.4

## Install build dependencies
RUN apt-get update \
    && apt-get install -y wget

## Download CAS module & configure
RUN wget https://github.com/apereo/mod_auth_cas/archive/refs/tags/v1.2.tar.gz \
    && tar -xvzf mod_auth_cas-1.2.tar.gz
WORKDIR /mod_auth_cas-1.2
RUN autoreconf -ivf \
    && ./configure --with-apxs=/usr/local/apache2/bin/apxs \
    && make \
    && make install

## Uncomment httpd-vhosts.conf in extras to enable custom vhost support
RUN sed -i '/httpd-vhosts.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

## Load modules
RUN echo "LoadModule proxy_module /usr/local/apache2/modules/mod_proxy.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule proxy_http_module /usr/local/apache2/modules/mod_proxy_http.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule rewrite_module /usr/local/apache2/modules/mod_rewrite.so" >> /usr/local/apache2/conf/httpd.conf
