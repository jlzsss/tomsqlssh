# jihuama/tomsqlssh
This project build a docker container, based on ubuntu16.04, include openjdk,tomcat7,mysql,vim.
Open ports 8080,3306,22.
All password is 123456
# China TimeZone
docker run --name mytomsql -d -p 9090:8080 -d -p 55:22 -d -p 3306:3306 jihuama/tomsqlssh
# Other TimeZone
docker run --name mytomsql -e TZ='Europe/Vienna' -d -p 9090:8080 -d -p 55:22 -d -p 3306:3306 jihuama/tomsqlssh
