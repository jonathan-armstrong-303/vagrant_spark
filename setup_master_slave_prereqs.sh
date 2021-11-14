

# install applications as root
  sudo su -

# assign master and slave IP's
  spark_master_ip="192.168.0.100"
  spark_slave_ip_1="192.168.0.101"
  spark_slave_ip_2="192.168.0.102"

# change to the root directory
  cd /

# Get rid of some of the author's common bash shell default annoyances

  echo "HISTFILESIZE=2000" >> ~/.bashrc
  echo "set -o vi" >> ~/.bashrc

# Set up some useful aliases [note user is root -- we will set up for gpadmin later]
  echo "alias master='ssh root@${spark_master_ip}'" >> ~/.bashrc
  echo "alias slave1='ssh root@${spark_slave_ip_1}'" >> ~/.bashrc
  echo "alias slave2='ssh root@${spark_slave_ip_2}'" >> ~/.bashrc

# modify /etc/hosts for Spark cluster
  echo ${spark_master_ip} "master" >> /etc/hosts
  echo ${spark_slave_ip_1} "slave01" >> /etc/hosts
  echo ${spark_slave_ip_2} "slave02" >> /etc/hosts

# Note: the formerly trusty "ppa:webupd8team/java" repo was discontinued sometime in 2019
# due to some Oracle/Java licensing chicanery.  In the event the ppa:ts.sch.gr/ppa subtitute
# repo is discontinued, a lengthier explanation with [hopefully] relevant addenda is here:
# https://askubuntu.com/questions/1139387/update-to-latest-version-of-java-after-ppa-is-discontinued

  echo "Installing Java using Oracle package"

  apt update
  apt-get upgrade -y

  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
  apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main' -y
  apt update
  apt install zulu-14 -y

echo "Checking java version installed... 2 second sleep..."
  java -version
sleep 2

echo "Installing Scala"
  apt-get install scala

echo "Checking Scala version installed... 2 second sleep..."
  scala -version
sleep 2

  wget -q https://archive.apache.org/dist/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz

  tar xf spark-3.1.2-bin-hadoop3.2.tgz

  mv spark-3.1.2-bin-hadoop3.2 /usr/local/spark

echo "export PATH=$PATH:/usr/local/spark/bin" >> ~/.bashrc

source ~/.bashrc

####### AT THIS POINT SEE IF /usr/local/spark directory is created and all ancillary subdirectories /usr/local/spark/conf etc
