#!/bin/bash
service mysql start # start mysql
service php7.4-fpm start # start fpm
nginx -g "daemon off;" # start nginx (and block process)
