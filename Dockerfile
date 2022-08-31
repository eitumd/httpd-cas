FROM httpd:2.4

## Install build dependencies
RUN apt-get update \
    && apt-get install -y wget dh-autoreconf libapr1-dev libaprutil1-dev libssl-dev libcurl4-openssl-dev libpcre3-dev build-essential

## Download CAS module & configure
WORKDIR /
RUN wget https://github.com/apereo/mod_auth_cas/archive/refs/tags/v1.2.tar.gz \
    && tar -xvzf v1.2.tar.gz
RUN cd /mod_auth_cas-1.2 \
    && autoreconf -iv \
    && ./configure --with-apxs=/usr/local/apache2/bin/apxs \
    && make \
    && make install

## Remove build dependencies & other build files
RUN apt-get remove -y wget dh-autoreconf libapr1-dev libaprutil1-dev libssl-dev libcurl4-openssl-dev libpcre3-dev build-essential \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /mod_auth_cas-1.2

## Uncomment httpd-vhosts.conf in extras to enable custom vhost support
RUN sed -i '/httpd-vhosts.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

## Load modules
RUN echo "## Load Extra Modules ##" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule proxy_module /usr/local/apache2/modules/mod_proxy.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule proxy_http_module /usr/local/apache2/modules/mod_proxy_http.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule rewrite_module /usr/local/apache2/modules/mod_rewrite.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule auth_cas_module /usr/local/apache2/modules/mod_auth_cas.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule headers_module /usr/local/apache2/modules/mod_headers.so" >> /usr/local/apache2/conf/httpd.conf

# Add CAS config
RUN mkdir -p /var/cache/apache2/mod_auth_cas \
    && chown -R www-data:www-data /var/cache/apache2 \
    && echo "## CAS Config ##" >> /usr/local/apache2/conf/httpd.conf \
    && echo "CASCookiePath /var/cache/apache2/mod_auth_cas/" >> /usr/local/apache2/conf/httpd.conf \
    && echo "CASLoginURL https://shib.idm.umd.edu/shibboleth-idp/profile/cas/login" >> /usr/local/apache2/conf/httpd.conf \
    && echo "CASValidateURL https://shib.idm.umd.edu/shibboleth-idp/profile/cas/serviceValidate" >> /usr/local/apache2/conf/httpd.conf
