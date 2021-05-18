#!/bin/bash

##Install the needed packages and enable the services(MariaDb, Apache)
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd

##Add ec2-user to Apache group and grant permissions to /var/www
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd /var/www/html
mkdir -p /etc/tls

#Install wordpress and unzip it/copy the sample php conf to wp-config


git clone https://github.com/stackitgit/CliXX_Retail_Repository.git
cp -r CliXX_Retail_Repository/* /var/www/html



##replace and set db_name,user_name, password, and host
sudo cp  /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i s/database_name_here/${DB_NAME}/ /var/www/html/wp-config.php
sudo sed -i s/username_here/${DB_USER}/ /var/www/html/wp-config.php
sudo sed -i s/password_here/${DB_PASSWORD}/ /var/www/html/wp-config.php 
sudo sed -i s/localhost/${DB_HOST}/ /var/www/html/wp-config.php 


## Allow wordpress to use Permalinks
sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf

##Grant file ownership of /var/www & its contents to apache user
sudo chown -R apache /var/www

##Grant group ownership of /var/www & contents to apache group
sudo chgrp -R apache /var/www

##Change directory permissions of /var/www & its subdir to add group write 
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;

##Recursively change file permission of /var/www & subdir to add group write perm
sudo find /var/www -type f -exec sudo chmod 0664 {} \;

##Restart Apache
sudo systemctl restart httpd
sudo service httpd restart

##Enable httpd 
sudo systemctl enable httpd 
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5

sudo /bin/cat <<EOP>/tmp/config.sh
MYSQL_USER="${DB_USER}"
MYSQL_PASS="${DB_PASSWORD}"
EOP

sudo /bin/cat <<EOP>/tmp/postinstall.sh
#!/bin/bash

source /tmp/config.sh

#UPDATE wp_options SET option_value = "http://`curl http://169.254.169.254/latest/meta-data/public-ipv4`" WHERE option_value LIKE 'http%';
#UPDATE wp_options SET option_value = "http://${Load_Balancer}" WHERE option_value LIKE 'http%';
mysql -h ${DB_HOST} -D ${DB_NAME} -u\$MYSQL_USER -p\$MYSQL_PASS<<EOF
show databases;
use wordpressdb;
UPDATE wp_options SET option_value = "http://`curl http://169.254.169.254/latest/meta-data/public-ipv4`" WHERE option_value LIKE 'http%';
commit;
EOF
EOP

sudo chmod 755 /tmp/postinstall.sh
sudo /tmp/postinstall.sh