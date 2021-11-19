#!/usr/bin/bash

echo "Installing applications"

# install applications as root
sudo su -

# change to the root directory
cd /

# software packages to be installed on mdw, smdw, sdw1 & sdw2
# Most of these are already installed on Centos/8 base box, but included for posterity -- 
# namely because I'm trying to get passwordless ssh working using this previous config
yum install apr-util -y
yum install apr -y
yum install bash -y
yum install bc -y
yum install bzip2 -y
yum install calc -y
yum install curl -y
yum install ed -y
yum install epel-release -y
yum install expect -y
yum install krb5  -y
yum install krb5-devel -y
yum install libcurl -y
yum install libevent -y
yum install libxml2 -y
yum install libyaml -y
yum install net-tools -y
yum install ntp -y
yum install openldap -y
yum install openssh -y
yum install openssh-server -y
yum install openssl-libs
yum install openssl -y
yum install perl -y
yum install readline -y
yum install rsync -y
yum install R -y
yum install sed -y
yum install sshpass -y
yum install tar -y
yum install vim -y
yum install wget -y
yum install zip -y
yum install zlib -y

# have to install apt-get separately, because I was previously trying to install Spark on Ubuntu 20.04
# but could not get passwordless ssh to work!
#curl https://raw.githubusercontent.com/dvershinin/apt-get-centos/master/apt-get.sh -o /usr/local/bin/apt-get
#chmod 0755 /usr/local/bin/apt-get
