#!/bin/bash
set -e

if [ "$DOC_ROOT" == "" ]; then
  DOC_ROOT="/var/www/web"
else
  DOC_ROOT=${DOC_ROOT//\"/}
  DOC_ROOT=${DOC_ROOT//\'/}
fi

cat <<EOF > /usr/local/apache2/conf/vhost.conf
<VirtualHost *:80>
    servername localhost
    serveralias *.localhost
    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php:9000$DOC_ROOT/\$1
    ProxyTimeout 300
    DocumentRoot "$DOC_ROOT"
    <Directory "$DOC_ROOT">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
<VirtualHost *:443>
    servername localhost
    serveralias *.localhost
    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php:9000$DOC_ROOT/\$1
    ProxyTimeout 300
    DocumentRoot "$DOC_ROOT"
    
    <Directory "$DOC_ROOT">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    SSLEngine on
    SSLCertificateFile conf/server.crt
    SSLCertificateKeyFile conf/server.key
    #SSLCACertificateFile /etc/ssl/{{deployer_user}}/CAbundle.pem

    SSLProtocol all -SSLv2 -SSLv3 -TLSv1.1
    SSLHonorCipherOrder on
    SSLCompression off
    SSLOptions +StrictRequire
    SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA
    
</VirtualHost>
EOF
exec "$@"