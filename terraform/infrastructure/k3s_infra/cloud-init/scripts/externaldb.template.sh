#!/bin/bash


# my sql
yum update -y oracle-cloud-agent
yum install -y mariadb-server.x86_64

systemctl stop oracle-cloud-agent

systemctl enable mariadb
systemctl start mariadb

cat > mysql_secure_installation.sql << EOF
UPDATE mysql.user SET Password=PASSWORD('${sqlpassword}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
#DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
CREATE USER k3s@localhost IDENTIFIED BY '${sqlpassword}';
GRANT ALL ON *.* to k3s@'10.0.0.0/255.0.0.0' IDENTIFIED BY '${sqlpassword}';
FLUSH PRIVILEGES;
EOF

mysql -u root < mysql_secure_installation.sql
#rm mysql_secure_installation.sql