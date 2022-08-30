FROM httpd:2.4

## Uncomment httpd-vhosts.conf in extras to enable custom vhost support
RUN sed -i '/httpd-vhosts.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

## Load modules
RUN echo "LoadModule mod_proxy /usr/local/apache2/modules/mod_proxy.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule mod_proxy_http /usr/local/apache2/modules/mod_proxy_http.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule mod_rewrite /usr/local/apache2/modules/mod_rewrite.so" >> /usr/local/apache2/conf/httpd.conf
