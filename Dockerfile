FROM httpd

RUN apt-get update && apt-get -y install vim nano iputils-ping net-tools

COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY server.key /usr/local/apache2/conf/server.key
COPY server.crt /usr/local/apache2/conf/server.crt