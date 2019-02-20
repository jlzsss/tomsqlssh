#!/bin/bash
chown -R mysql:mysql /var/lib/mysql
service mysql start & /usr/local/tomcat/bin/catalina.sh run & /usr/sbin/sshd -D 
