sestatus 
sudo apt update
sudo apt install policycoreutils -y
sed -i 's/SELINUX=[a-z]*/SELINUX=disabled/' /etc/selinux/config
