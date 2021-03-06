# run all this script as root.
  sudo su -

# Whatever you want the sparkadmin password to be.  It just has to fit some basic
# security requirements (e.g., can't be "sparkadmin", etc)
# sparkadmin is not even necessary in getting the basic install up and running
  sparkadmin_password="r0xs0xb0x"

# assign master and slave IP's
  spark_master_ip="192.168.0.200"
  spark_slave_ip_1="192.168.0.201"
  spark_slave_ip_2="192.168.0.202"

# Create sparkadmin user and group 
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

# setup ssh directories and enforce the (irritatingly particular) permissions on them
  cd /home/sparkadmin
  mkdir /home/sparkadmin/.ssh
  chmod 700  /home/sparkadmin/.ssh

  touch /home/sparkadmin/.ssh/id_rsa
  touch /home/sparkadmin/.ssh/id_rsa.pub
  touch /home/sparkadmin/.ssh/authorized_keys
  touch /home/sparkadmin/.ssh/known_hosts

  chmod 600 /home/sparkadmin/.ssh/id_rsa
  chmod 644 /home/sparkadmin/.ssh/id_rsa.pub
  chmod 644 /home/sparkadmin/.ssh/authorized_keys
  chmod 644 /home/sparkadmin/.ssh/known_hosts

# set up some common aliases and get rid of some of the author's annoyances in both /root and /sparkadmin
  echo "HISTFILESIZE=2000" | tee -a /root/.bashrc /home/sparkadmin/.bashrc
  echo "set -o vi" | tee -a /root/.bashrc /home/sparkadmin/.bashrc

# Set up some useful aliases [note user is root -- we will set up for sparkadmin later]
  echo "alias master='ssh root@${spark_master_ip}'" | tee -a /root/.bashrc /home/sparkadmin/.bashrc
  echo "alias slave1='ssh root@${spark_slave_ip_1}'" | tee -a /root/.bashrc /home/sparkadmin/.bashrc
  echo "alias slave2='ssh root@${spark_slave_ip_2}'" | tee -a /root/.bashrc /home/sparkadmin/.bashrc

# Allow sparkadmin sudo privileges and get rid of password prompt annoyance
   #actual GP documentation states to use "wheel" line below... ymmv
   #%wheel        ALL=(ALL)       NOPASSWD: ALL
   echo "sparkadmin ALL=(ALL) ALL" >> /etc/sudoers
   echo "sparkadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# modify /etc/hosts for Spark cluster
  echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
  echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
  echo ${spark_master_ip} "master" >> /etc/hosts
  echo ${spark_slave_ip_1} "slave01" >> /etc/hosts
  echo ${spark_slave_ip_2} "slave02" >> /etc/hosts

# All of these SHOULD be set to the working values right out of the box, but for a  host of reasons
# I struggled a lot with getting passwordless ssh running on this cluster. 
# Optional script can be run after installation to reset these to more security-conscious values.
# Default values in /etc/ssh/sshd_config out of the box should be:
#   PasswordAuthentication no
#   ChallengeResponseAuthentication no
#   UsePAM yes

   sed -ie '/^PermitRootLogin no/d' /etc/ssh/sshd_config
   sed -ie '/^PermitRootLogin no/PermitRootLogin yes' /etc/ssh/sshd_config

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

echo "Installing Zulu Java JDK"
  yum update -y
  yum upgrade -y
  yum install -y https://cdn.azul.com/zulu/bin/zulu-repo-1.0.0-1.noarch.rpm
  yum install -y zulu11-jdk

# Install Java
echo "Checking java version installed... 2 second sleep..."
  java -version
sleep 2

# Install Scala
echo "Installing Scala"
  yum install -y scala

echo "Checking Scala version installed... 2 second sleep..."
  scala -version
sleep 2

# Download and extract Spark binaries
echo "downloading Spark 3.1.2, untarring, and moving..."
  wget -q https://archive.apache.org/dist/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
  tar xf spark-3.1.2-bin-hadoop3.2.tgz
  mv spark-3.1.2-bin-hadoop3.2 /usr/local/spark

#add to $PATH
echo "export PATH=$PATH:/usr/local/spark/bin" |tee -a /root/.bashrc /home/sparkadmin/.bashrc
