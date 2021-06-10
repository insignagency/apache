FROM httpd

RUN apt-get update && apt-get -y install vim nano iputils-ping net-tools

COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY entrypoint.sh /entrypoint.sh
COPY server.key /usr/local/apache2/conf/server.key
COPY server.crt /usr/local/apache2/conf/server.crt

ENTRYPOINT ["/entrypoint.sh"]
CMD ["httpd", "-D", "FOREGROUND"]

EXPOSE 80
EXPOSE 443