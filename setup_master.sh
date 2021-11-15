#!/bin/bash

# this script should be run as sparkadmin. copy this script over to Vagrant spark-master node
# with the following command, then just execute it in the home diretory, i.e., 
# scp setup_master_gpadmin_ssh.sh sparkadmin@spark-master:/home/sparkadmin

  sparkadmin_password='r0xs0xb0x'

# create all necessary files (superfluous? yes, but at least this documents all of the annoying/picky
# permissions that are necessary as breadcrumbs for future reference
  mkdir -p ~/.ssh
  chmod 700  ~/.ssh
  touch ~/.ssh/id_rsa
  touch ~/.ssh/id_rsa.pub
  touch ~/.ssh/authorized_keys
  touch ~/.ssh/known_hosts
  chmod 600 ~/.ssh/id_rsa
  chmod 644 ~/.ssh/id_rsa.pub
  chmod 600 ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/known_hosts


# install expect
  apt-get install expect -y

# only install openssh-server on master
  apt-get install openssh-server openssh-client -y

# Generate ssh key
/usr/bin/expect<<EOF
  spawn ssh-keygen 
  expect "Enter file in which to save the key (/root/.ssh/id_rsa): "
  send  "\r"
  expect "Enter passphrase (empty for no passphrase): "
  send  "\r"
  expect "Enter same passphrase again: "
  send  "\r"
  expect
EOF

# copy over id_rsa.pub ssh key to standby / segment servers
# yes, this violates DRY  -- but was having issues wrapping this in a for loop. Go figure!

spark_server="slave01"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${spark_server}
  expect "Are you sure you want to continue connecting (yes/no)? "
  send "yes\r"
  expect "${spark_server}'s password: "
  send  "${sparkadmin_password}\r"
  expect
EOF

spark_server="slave02"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${spark_server}
  expect "Are you sure you want to continue connecting (yes/no)? "
  send "yes\r"
  expect "${spark_server}'s password: "
  send  "${sparkadmin_password}\r"
  expect
EOF

# do the remaining config setup as root

  sudo su -
  cp /usr/local/spark/conf/spark-env.sh.template  /usr/local/spark/conf/spark-env.sh

  echo "export SPARK_MASTER_HOST='<MASTER-IP>'" >> /usr/local/spark/conf/spark-env.sh
  echo "export JAVA_HOME=`which java`" >> /usr/local/spark/conf/spark-env.sh

  echo "master" > /usr/local/spark/conf/slaves
  echo "slave01" > /usr/local/spark/conf/slaves
  echo "slave02" > /usr/local/spark/conf/slaves


