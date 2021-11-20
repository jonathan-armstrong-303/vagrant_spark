#!/bin/bash
# assign password -- needs to be the same throughout the process of course
  root_password="vagrant"
  spark_master_ip="128.198.0.200"

# activities to facilitate passwordless ssh.
# make ssh directory and apply right permissions.  Very important!

  mkdir -p ~/.ssh
  chmod 700  ~/.ssh

# Apply permissions below.  Superfluous?  Yes. Not all these files are generated, but permissions
# included for posterity/breadcrumbs since the author can never remember them
  touch ~/.ssh/authorized_keys
  touch ~/.ssh/known_hosts
  chmod 644 ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/known_hosts


# ACTUALLY RUNNING/TESTING AS ROOT
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

  chmod 600 ~/.ssh/id_rsa
  chmod 644 ~/.ssh/id_rsa.pub

# copy over id_rsa.pub ssh key to standby / segment servers

# yeah, I know this is an egregious violation of DRY right here, but was having some issues
# wrapping the expect script in a for loop. 
sparkserver="slave01"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${sparkserver}
  expect "Are you sure you want to continue connecting (yes/no/\[fingerprint\])? "
  send "yes\r"
  sleep 1
  expect "root@${sparkserver}'s password: "
  send  "${root_password}\r"
  sleep 1
  expect
EOF

sparkserver="slave02"
  /usr/bin/expect<<EOF
  spawn ssh-copy-id ${sparkserver}
  expect "Are you sure you want to continue connecting (yes/no/\[fingerprint\])? "
  send "yes\r"
  sleep 1
  expect "root@${sparkserver}'s password: "
  send  "${root_password}\r"
  sleep 1
  expect
EOF

# now finish up some final Spark config file stuff
# Don't ask me why/how the JAVA_HOME setup works.  If you put the actual JAVA_HOME
# (i.e., `which java` output) it will double up the JAVA_HOME path and throw
# the following error when you execute spark-shell:
# /usr/local/spark/bin/spark-class: line 71: /bin/java/bin/java: Not a directory

  cp /usr/local/spark/conf/spark-env.sh.template  /usr/local/spark/conf/spark-env.sh

  echo "export SPARK_MASTER_HOST='${spark_master_ip}'" >> /usr/local/spark/conf/spark-env.sh
  echo "export JAVA_HOME=/" >> /usr/local/spark/conf/spark-env.sh

  echo "master" > /usr/local/spark/conf/slaves
  echo "slave01" >> /usr/local/spark/conf/slaves
  echo "slave02" >> /usr/local/spark/conf/slaves

