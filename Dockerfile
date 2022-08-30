FROM httpd:2.4

## Install mod_auth_cas
RUN apt-get update
RUN apt-get -y install libapache2-mod-auth-cas
