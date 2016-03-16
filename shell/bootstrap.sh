#!/usr/bin/env bash

# Repository configs
# Basic updates, keys added and java configured
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
yum -y install http://ucmirror.canterbury.ac.nz/linux/fedora/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
wget –-quiet http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
yum clean all && yum makecache fast
yum -y install deltarpm git bash-completion apache-maven bind-utils mysql
yum -y update --skip-broken --exclude=kernel*


cd ~
wget --no-cookies --no-check-certificate –-quiet --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jre-8u60-linux-x64.rpm"

wget --no-cookies \
--no-check-certificate \
–-quiet --header "Cookie: oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.rpm" \
-O jdk-7-linux-x64.rpm

yum -y localinstall *.rpm
export JAVA_HOME=/usr/lib/jvm/java-7-oracle/

# Adding swap space
# Size of swapfile in megabytes
swapsize=8000

# Does the swap file already exist?
grep -q "swapfile" /etc/fstab

# If not then create it
if [ $? -ne 0 ]; then
  echo 'swapfile not found. Adding swapfile.'
  fallocate -l ${swapsize}M /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
  echo 'swapfile found. No changes made.'
fi

# Output results to terminal
df -h
cat /proc/swaps
cat /proc/meminfo | grep Swap

# Download jobs
# Directory in guest VM where the WSO2 files will be downloaded
# '/vagrant' is a folder to share between Host and Guest
mkdir -p /vagrant/_downloads
cd /vagrant/_downloads

# Postgres Driver
FILE=postgresql-9.4-1201.jdbc41.jar

if [ -f $FILE ];
then
   echo "'"$FILE"' JDBC driver already downloaded."
else
   wget –-quiet https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar
fi

# MySQL Driver
FILE=mysql-connector-java-5.1.30.tar.gz

if [ -f $FILE ];
then
   echo "'"$FILE"' JDBC driver already downloaded."
else
   wget –-quiet http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.30.tar.gz
fi

# ESB 4.9.0
FILE=wso2esb-4.9.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget –-quiet --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://dist.wso2.org/products/enterprise-service-bus/4.9.0/wso2esb-4.9.0.zip
fi

# AS 5.2.1
FILE=wso2as-5.2.1.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget –-quiet --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/application-server/5.2.1/wso2as-5.2.1.zip
fi

# AM 1.10.0
FILE=wso2am-1.10.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget –-quiet --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/api-manager/1.10.0/wso2am-1.10.0.zip
fi

# GREG 5.1.0
FILE=wso2greg-5.1.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget –-quiet --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/governance-registry/5.1.0/wso2greg-5.1.0.zip
fi

## DSS 3.5.0
FILE=wso2dss-3.5.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget –-quiet --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/data-services-server/3.5.0/wso2dss-3.5.0.zip
fi

## IS 5.1.0
FILE=wso2is-5.1.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget –-quiet --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/identity-server/5.1.0/wso2is-5.1.0.zip
fi

## DAS 3.0.1
FILE=wso2das-3.0.1.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget –-quiet --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/data-analytics-server/3.0.1/wso2das-3.0.1.zip
fi

