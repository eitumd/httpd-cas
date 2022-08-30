FROM httpd:2.4

## Install mod_auth_cas
RUN apt-get update
RUN apt-get -y install libapache2-mod-auth-cas

## Uncomment httpd-vhosts.conf in extras
RUN sed -i "/http-vhosts.conf/s/^#//g" /usr/local/apache2/conf/httpd.conf
RUN cat /usr/local/apache2/conf/httpd.conf | grep http-vhosts.conf
