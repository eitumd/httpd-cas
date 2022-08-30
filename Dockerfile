FROM httpd:2.4

## Install mod_auth_cas
RUN apt update
RUN apt install libapache2-mod-auth-cas
