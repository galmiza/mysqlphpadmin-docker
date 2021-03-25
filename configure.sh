#!/bin/bash

# download and unpack phpMyAdmin 5.1.0
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip
unzip phpMyAdmin-5.1.0-all-languages.zip
ln -s /phpMyAdmin-5.1.0-all-languages /var/www/html/phpmyadmin

# configure fpm 7.4
sed -i -e 's/fix_pathinfo=1/fix_pathinfo=0/g' /etc/php/7.4/fpm/php.ini # change value for cgi.fix_pathinfo
sed -i -e 's/;cgi.fix_pathinfo=/cgi.fix_pathinfo=/g' /etc/php/7.4/fpm/php.ini # uncomment cgi.fix_pathinfo

# configure mysql
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf # bind to any ip
service mysql start
mysql << EOF
UPDATE mysql.user SET Host='%' WHERE Host='localhost' AND User='root';
UPDATE mysql.db SET Host='%' WHERE Host='localhost' AND User='root';
FLUSH PRIVILEGES;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
FLUSH PRIVILEGES;
EOF
service mysql stop

# configure nginx
cat nginx.conf > /etc/nginx/sites-available/default
