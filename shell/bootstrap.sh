#!/usr/bin/env bash

# Repository configs
# Basic updates, keys added and java configured
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
yum -y install http://ucmirror.canterbury.ac.nz/linux/fedora/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo \
-O /etc/yum.repos.d/epel-apache-maven.repo 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
yum clean all && yum makecache fast
yum -y install deltarpm git bash-completion bind-utils mysql puppet
yum -y update --skip-broken --exclude=kernel*

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

if ! rpm -qa | grep -qw jre1.8; then
    wget --no-cookies \
    --no-check-certificate \
    --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jre-8u60-linux-x64.rpm" 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

if ! rpm -qa | grep -qw jdk-1.7; then
    wget --no-cookies \
    --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.rpm" \
    -O jdk-7-linux-x64.rpm 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log

    wget --no-cookies \
    --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip" \
    -O UnlimitedJCEPolicyJDK7.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

yum -y localinstall *.rpm
export JAVA_HOME=/usr/lib/jvm/java-7-oracle/
rm -rf /usr/java/default/lib/security/local_policy.jar
rm -rf /usr/java/default/lib/security/US_export_policy.jar


# Postgres Driver
FILE=postgresql-9.4-1201.jdbc41.jar

if [ -f $FILE ];
then
   echo "'"$FILE"' JDBC driver already downloaded."
else
   wget -Sq https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

# MySQL Driver
FILE=mysql-connector-java-5.1.38.tar.gz

if [ -f $FILE ];
then
   echo "'"$FILE"' JDBC driver already downloaded."
else
   wget -Sq http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

rm -rf mysql-connector-java-5.1.38-bin.jar && tar -xzf mysql-connector-java-5.1.38.tar.gz && cp -R mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar . && rm -rf mysql-connector-java-5.1.38/

# ESB 4.9.0
FILE=wso2esb-4.9.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget -Sq --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://dist.wso2.org/products/enterprise-service-bus/4.9.0/wso2esb-4.9.0.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

# AS 5.2.1
FILE=wso2as-5.2.1.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget -Sq --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/application-server/5.2.1/wso2as-5.2.1.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

# AM 1.10.0
FILE=wso2am-1.10.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget -Sq --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/api-manager/1.10.0/wso2am-1.10.0.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

# GREG 5.1.0
FILE=wso2greg-5.1.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget -Sq --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/governance-registry/5.1.0/wso2greg-5.1.0.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

## DSS 3.5.0
FILE=wso2dss-3.5.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget -Sq --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/data-services-server/3.5.0/wso2dss-3.5.0.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

## IS 5.1.0
FILE=wso2is-5.1.0.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget -Sq --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/identity-server/5.1.0/wso2is-5.1.0.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

## DAS 3.0.1
FILE=wso2das-3.0.1.zip

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget -Sq --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/data-analytics-server/3.0.1/wso2das-3.0.1.zip 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

## Apache ActiveMQ
FILE=apache-activemq-5.12.3-bin.tar.gz

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget http://www-us.apache.org/dist/activemq/5.12.3/apache-activemq-5.12.3-bin.tar.gz 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

## Apache Ant
FILE=apache-ant-1.9.6-bin.tar.gz

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget http://www-eu.apache.org/dist//ant/binaries/apache-ant-1.9.6-bin.tar.gz 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

## Apache Maven
FILE=apache-maven-3.3.9-bin.tar.gz

if [ -f $FILE ];
then
   echo "'"$FILE"' already downloaded."
else
   wget http://www-us.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz 2>/tmp/err.log || cat /tmp/err.log; rm -f /tmp/err.log
fi

