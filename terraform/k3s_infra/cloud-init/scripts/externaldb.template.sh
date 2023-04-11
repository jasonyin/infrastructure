#!/bin/bash

echo 'Initializing k3s external db server'

# my sql
yum update -y oracle-cloud-agent
yum install -y mariadb-server.x86_64

systemctl stop oracle-cloud-agent

systemctl enable mariadb
systemctl start mariadb

cat > mysql_secure_installation.sql << EOF
UPDATE mysql.user SET Password=PASSWORD('${sqlpassword}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
CREATE DATABASE k3sdb;
CREATE USER k3s@localhost IDENTIFIED BY '${sqlpassword}';
GRANT ALL ON *.* to k3s@localhost IDENTIFIED BY '${sqlpassword}';
#DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;
EOF

mysql -u root < mysql_secure_installation.sql
#rm mysql_secure_installation.sql

#firewall-cmd --permanent --add-port=3306/tcp
iptables -A INPUT -i ens3 -p tcp --destination-port 3306 -j ACCEPT

systemctl start oracle-cloud-agent