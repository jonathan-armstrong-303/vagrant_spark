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

# CHECK EXISTENCE OF /usr/local/sparkadmin here
# If not mkdir -p /usr/local/sparkadmin

# Allow sparkadmin sudo privileges and get rid of password prompt annoyance
   #actual GP documentation states to use "wheel" line below... ymmv
   #%wheel        ALL=(ALL)       NOPASSWD: ALL
   echo "sparkadmin ALL=(ALL) ALL" >> /etc/sudoers
   echo "sparkadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Grant sparkadmin sudo privileges.  This eliminiates the (IMHO annoying)
# need to enter the password every time you sudo.

echo "sparkadmin ALL=(ALL) ALL" >> /etc/sudoers
echo "sparkadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#change the directory ownership to sparkadmin after creation
#[] -- I just don't know what directory(s) exactly to change yet
#   sudo chown -R gpadmin:gpadmin /usr/local/greenplum*
#   sudo chgrp -R gpadmin /usr/local/greenplum* 

#install spark binaries

wget https://www.apache.org/dyn/closer.lua/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz

tar -xvf spark-3.1.2-bin-hadoop3.2.tgz

mv spark-3.1.2-bin-hadoop3.2 /usr/local/spark

echo "export PATH = $PATH:/usr/local/spark/bin" >> ~/.bashrc

source ~/.bashrc 
