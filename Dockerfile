FROM httpd:2.4

## Uncomment httpd-vhosts.conf in extras to enable custom vhost support
RUN sed -i '/httpd-vhosts.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

## Load modules
RUN echo "LoadModule proxy_module /usr/local/apache2/modules/mod_proxy.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule proxy_http_module /usr/local/apache2/modules/mod_proxy_http.so" >> /usr/local/apache2/conf/httpd.conf
RUN echo "LoadModule rewrite_module /usr/local/apache2/modules/mod_rewrite.so" >> /usr/local/apache2/conf/httpd.conf
