# VERSION 1.0.1
FROM i386/ubuntu:16.04
# Auther 
MAINTAINER charles "jihua.ma@gmail.com"
ENV TZ Asia/Shanghai
RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p mkdir/root/.ssh/
# ssh remote login password is 123456
RUN echo "root:123456" | chpasswd 
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# Install jdk
RUN apt-get install -y openjdk-8-jdk vim
# Install mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
# Setup mysql root password is 123456 & remote access
RUN chown -R mysql:mysql /var/lib/mysql && /etc/init.d/mysql start \
&&  mysql -uroot -e "grant all privileges on *.* to 'root'@'%' identified by '123456';" \
&&  mysql -uroot -e "grant all privileges on *.* to 'root'@'localhost' identified by '123456';" 
RUN sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf 
# Install Tomcat7
RUN wget http://mirrors.hust.edu.cn/apache/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz && \
tar xvf apache-tomcat-7.0.92.tar.gz -C /usr/local && mv /usr/local/apache-tomcat-7.0.92 /usr/local/tomcat
RUN rm -f apache-tomcat-7.0.92.tar.gz
# Add Tomcat Manager Gui user & password
RUN echo '<tomcat-users> \
<role rolename="manager-gui"/> \
<user username="tomcat" password="123456" roles="manager-gui"/> \
</tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml
# Setup Timezone
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
# Export SSH port
EXPOSE 22
# Export Tomcat 8080 port
EXPOSE 8080
# Export Mysql 3306 port
EXPOSE 3306
# Start up mysql tomcat and ssh server
COPY startup.sh /root/startup.sh
RUN chmod a+x /root/startup.sh
ENTRYPOINT /root/startup.sh
