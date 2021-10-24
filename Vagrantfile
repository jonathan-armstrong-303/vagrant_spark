Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/hirsute64"
  config.disksize.size = '100GB'
  config.vm.box_download_insecure=true

  config.vm.define "spark-master" do |node|
    node.vm.hostname = "spark-master"
    node.vm.network :private_network, ip: "192.168.0.100"
#    node.vm.provision :shell, :path => "setup_master_slave.sh"
  end

  config.vm.define "spark-worker-1" do |node|
    node.vm.box = "ubuntu/hirsute64"
    node.vm.hostname = "spark-worker-1"
    node.vm.network :private_network, ip: "192.168.0.101"
#    node.vm.provision :shell, :path => "setup_master_slave.sh"
  end

  config.vm.define "spark-worker-2" do |node|
    node.vm.box = "ubuntu/hirsute64"
    node.vm.hostname = "spark-worker-2"
    node.vm.network :private_network, ip: "192.168.0.102"
#    node.vm.provision :shell, :path => "setup_master_slave.sh"
  end
  
  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 2
  end
end
