FROM httpd

RUN apt-get update && apt-get -y install vim nano iputils-ping net-tools

COPY httpd.conf /usr/local/apache2/conf/httpd.conf