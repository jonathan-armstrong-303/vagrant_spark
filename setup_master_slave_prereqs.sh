# install applications as root
  sudo su -

# sparkadmin password.  ensure this matches what is in the spark_master.sh file
  sparkadmin_password='r0xs0xb0x'

# assign master and slave IP's
  spark_master_ip="192.168.0.100"
  spark_slave_ip_1="192.168.0.101"
  spark_slave_ip_2="192.168.0.102"

# change to the root directory
  cd /

# Create sparkadmin user and group 
# Under a "normal" (i.e., non Vagrant VM) build I probably would have just built and run Spark all
# under root, at least for just testing purposes, but the interaction between Vagrant, ssh and root
# causes issues with a lot of 
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

# set up some common aliases and get rid of some of the author's annoyances in both /root and /sparkadmin
  echo "HISTFILESIZE=2000" | tee -a /root/.bashrc /sparkadmin/.bashrc
  echo "set -o vi" | tee -a /root/.bashrc /sparkadmin/.bashrc

# Set up some useful aliases [note user is root -- we will set up for sparkadmin later]
  echo "alias master='ssh root@${spark_master_ip}'" | tee -a /root/.bashrc /sparkadmin/.bashrc
  echo "alias slave1='ssh root@${spark_slave_ip_1}'" | tee -a /root/.bashrc /sparkadmin/.bashrc
  echo "alias slave2='ssh root@${spark_slave_ip_2}'" | tee -a /root/.bashrc /sparkadmin/.bashrc

# Allow sparkadmin sudo privileges and get rid of password prompt annoyance
  #actual GP documentation states to use "wheel" line below... ymmv
  #%wheel        ALL=(ALL)       NOPASSWD: ALL
  echo "sparkadmin ALL=(ALL) ALL" >> /etc/sudoers
  echo "sparkadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# modify /etc/hosts for Spark cluster
  echo ${spark_master_ip} "master" >> /etc/hosts
  echo ${spark_slave_ip_1} "slave01" >> /etc/hosts
  echo ${spark_slave_ip_2} "slave02" >> /etc/hosts

# set up sshd_config parameters to allow for ssh-copy-id and 
# All of these SHOULD be set to the working values as defaults, but check/replace as needed anyway.
# For whatever reason, I struggled a lot with getting passwordless ssh running on this cluster 
# (typically a fairly trivial task).
# Will reset these values back to more security-friendly configuration near install completion.
# Default values in /etc/ssh/sshd_config out of the box should be:
#   PasswordAuthentication no
#   ChallengeResponseAuthentication no
#   UsePAM yes

  sed -ie '/PasswordAuthentication no/d' /etc/ssh/sshd_config
  sed -ie 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

  sed -ie '/ChallengeResponseAuthentication no/d' /etc/ssh/sshd_config
  sed -ie 's/^#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config

  sed -ie 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
  sed -ie '/UsePAM yes/d' /etc/ssh/sshd_config

# restart sshd and stop firewalld
  systemctl restart sshd.service
  systemctl stop firewalld.service
  systemctl disable firewalld.service

# Ensure there are no iptables rules.
  echo "iptables output -- you shouldn't see any rules here..."
  iptables -L -v

# Note: the formerly trusty "ppa:webupd8team/java" repo was discontinued sometime in 2019
# Due to the irritating discontinuation by Oracle, we are using the Zulu Java distribution
# More detail on this can be found here:
# https://askubuntu.com/questions/1139387/update-to-latest-version-of-java-after-ppa-is-discontinued

  echo "Installing Java using Oracle package"

  apt update
  apt-get upgrade -y

  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
  apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main' -y
  apt update
  apt install zulu-14 -y

# Install Java
echo "Checking java version installed... 2 second sleep..."
  java -version
sleep 2

# Install Scala
echo "Installing Scala"
  apt-get install scala -y

echo "Checking Scala version installed... 2 second sleep..."
  scala -version
sleep 2

# Download and extract Spark binaries
echo "downloading Spark 3.1.2, untarring, and moving..."
  wget -q https://archive.apache.org/dist/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
  tar xf spark-3.1.2-bin-hadoop3.2.tgz
  mv spark-3.1.2-bin-hadoop3.2 /usr/local/spark

echo "export PATH=$PATH:/usr/local/spark/bin" >> ~/.bashrc

source ~/.bashrc
