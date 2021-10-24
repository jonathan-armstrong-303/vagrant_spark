#!/bin/bash

# run this whole preliminary install as root
  sudo su -

# assign password -- needs to be the same throughout the process of course
  sparkadmin_password="r0xs0xb0x"

# Create sparkadmin user and group 
# Note -- take out the hash before the "EOF" -- only added because the << messed up vi display colors
   groupadd sparkadmin
   useradd sparkadmin -r -m -g sparkadmin
   /usr/bin/expect <<EOF
   spawn passwd sparkadmin
   expect "New password: "
   send "${sparkadmin_password}\r"
   expect "Retype new password: "
   send  "${sparkadmin_password}\r"
   expect "passwd: all authentication tokens updated successfully."
EOF

# Allow sparkadmin sudo privileges and get rid of password prompt annoyance
   #actual GP documentation states to use "wheel" line below... ymmv
   #%wheel        ALL=(ALL)       NOPASSWD: ALL
   echo "sparkadmin ALL=(ALL) ALL" >> /etc/sudoers
   echo "sparkadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# activities to facilitate passwordless ssh.
# make ssh directory and apply right permissions.  Very important!
#################################################################
# RUN EVERYTHING BELOW HERE AS SPARKADMIN WITH DIFFERENT SCRIPT #
#################################################################

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

# Grant sparkadmin sudo privileges.  This eliminiates the (IMHO annoying)
# need to enter the password every time you sudo.

echo "sparkadmin ALL=(ALL) ALL" >> /etc/sudoers
echo "sparkadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#change the directory ownership to sparkadmin after creation
#[] -- I just don't know what directory(s) exactly to change yet
#   sudo chown -R gpadmin:gpadmin /usr/local/greenplum*
#   sudo chgrp -R gpadmin /usr/local/greenplum* 

wget https://www.apache.org/dyn/closer.lua/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz

tar -xvf spark-3.1.2-bin-hadoop3.2.tgz

# DO EVERYTHING BELOW "SPARK MASTER CONFIGURATION" SECTION
