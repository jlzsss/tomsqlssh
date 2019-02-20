# VERSION 1.0.1
FROM ubuntu:16.04
# 签名
MAINTAINER charles "jihua.ma@gmail.com"

RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p mkdir/root/.ssh/
# 设置root ssh远程登录密码为123456
RUN echo "root:123456" | chpasswd 
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# 安装jdk
RUN apt-get install -y openjdk-8-jdk vim
# 安装mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
# 设置mysql root密码为123456 设置远程访问权限
RUN chown -R mysql:mysql /var/lib/mysql && /etc/init.d/mysql start \
&&  mysql -uroot -e "grant all privileges on *.* to 'root'@'%' identified by '123456';" \
&&  mysql -uroot -e "grant all privileges on *.* to 'root'@'localhost' identified by '123456';" 
RUN sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf 
# 安装 Tomcat7
RUN wget http://mirrors.hust.edu.cn/apache/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz && \
tar xvf apache-tomcat-7.0.92.tar.gz -C /usr/local && mv /usr/local/apache-tomcat-7.0.92 /usr/local/tomcat
RUN rm -f apache-tomcat-7.0.92.tar.gz
# 增加Tomcat管理权限
RUN echo '<tomcat-users> \
<role rolename="manager-gui"/> \
<user username="tomcat" password="123456" roles="manager-gui"/> \
</tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml
# 开放SSH 22端口
EXPOSE 22
# 开放Tomcat 8080端口
EXPOSE 8080
# 开放 Mysql 3306
EXPOSE 3306
# 设置Tomcat7初始化运行，SSH终端服务器作为后台运行
#ENTRYPOINT service tomcat8 start && /usr/sbin/sshd -D
#ENTRYPOINT /usr/sbin/sshd -D
#ENTRYPOINT chown -R mysql:mysql /var/lib/mysql & service mysql start & /usr/local/tomcat/bin/catalina.sh run & /usr/sbin/sshd -D
COPY startup.sh /root/startup.sh
RUN chmod a+x /root/startup.sh
ENTRYPOINT /root/startup.sh
