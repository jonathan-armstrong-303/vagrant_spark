#!/bin/bash

# run this whole preliminary install as root
  sudo su -

# activities to facilitate passwordless ssh.
# make ssh directory and apply right permissions.  Very important!
#################################################################
# RUN EVERYTHING BELOW HERE AS SPARKADMIN WITH DIFFERENT SCRIPT #
#################################################################
#[]

  cd /home/sparkadmin
  mkdir ~/.ssh
  chmod 700  ~/.ssh
 
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

# apply right permissions to recently created keys.
  chmod 600 ~/.ssh/id_rsa
  chmod 644 ~/.ssh/id_rsa.pub

# Apply permissions below.  Superfluous?  Yes. Not all these files are generated, but permissions
# included for posterity/breadcrumbs since the author can never remember them

  touch ~/.ssh/authorized_keys
  touch ~/.ssh/known_hosts
  chmod 644 ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/known_hosts
  
#   chmod 700 ~/.ssh
#   chmod 600 ~/.ssh/id_rsa
#   chmod 644 ~/.ssh/id_rsa.pub
#   chmod 644 ~/.ssh/authorized_keys
#   chmod 644 ~/.ssh/known_hosts
#   restorecon -R ~/.ssh

# copy over id_rsa.pub ssh key to standby / segment servers

# yes, this is an egregious violation of DRY right here, but couldn't wrap the expect
# script in a for loop for some reason -- so triplicated it is
spark_server="master"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${spark_server}
  expect "Are you sure you want to continue connecting (yes/no)? "
  send "yes\r"
  expect "sparkadmin@${spark_server}'s password: "
  send  "${sparkadmin_password}\r"
  expect
EOF

spark_server="slave1"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${spark_server}
  expect "Are you sure you want to continue connecting (yes/no)? "
  send "yes\r"
  expect "sparkadmin@${spark_server}'s password: "
  send  "${sparkadmin_password}\r"
  expect
EOF

spark_server="slave2"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${spark_server}
  expect "Are you sure you want to continue connecting (yes/no)? "
  send "yes\r"
  expect "sparkadmin@${spark_server}'s password: "
  send  "${sparkadmin_password}\r"
  expect
EOF

# 
cp /usr/local/spark/conf/spark-env.sh.template  /usr/local/spark/conf/spark-env.sh

echo "export SPARK_MASTER_HOST='<MASTER-IP>'" >> /usr/local/spark/conf/spark-env.sh
echo "export JAVA_HOME=`which java`" >> /usr/local/spark/conf/spark-env.sh

echo "master" > /usr/local/spark/conf/slaves
echo "slave01" > /usr/local/spark/conf/slaves
echo "slave02" > /usr/local/spark/conf/slaves


