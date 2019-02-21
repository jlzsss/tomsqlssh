#!/bin/bash
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
chown -R mysql:mysql /var/lib/mysql
service mysql start & /usr/local/tomcat/bin/catalina.sh run & /usr/sbin/sshd -D 
