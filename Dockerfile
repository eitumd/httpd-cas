FROM httpd:2.4

## Install mod_auth_cas
RUN apt-get update
RUN apt-get -y install libapache2-mod-auth-cas

## Uncomment httpd-vhosts.conf in extras to enable custom vhost support
RUN sed -i '/httpd-vhosts.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

## Load modules
RUN echo "LoadModule mod_proxy /usr/lib/apache2/mod_proxy" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule mod_proxy_http /usr/lib/apache2/mod_proxy_http" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule mod_rewrite /usr/lib/apache2/mod_rewrite" >> /usr/local/apache2/conf/httpd.conf
