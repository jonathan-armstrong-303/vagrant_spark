# run the following from command line before running vagrant up: 
# vagrant box add --provider virtualbox --insecure centos/8

Vagrant.configure(2) do |config|
  config.vm.box = "centos/8"
  config.vm.box_version = "2011.0"
  config.disksize.size = '100GB'

  config.vm.define "spark-master" do |node|
        node.vm.hostname = "spark-master"
        node.vm.network :private_network, ip: "192.168.0.201"
        node.vm.provision :shell, reboot: true, :path => "disable_selinux.sh"
        node.vm.provision 'shell', inline: 'sestatus'
        node.vm.provision :shell, :path => "prerequisite_application_install.sh"
        node.vm.provision :shell, :path => "setup_host_params.sh"
  end
  config.vm.define "spark-worker-1" do |node|
        node.vm.hostname = "spark-worker-1"
        node.vm.network :private_network, ip: "192.168.0.202"
        node.vm.provision :shell, reboot: true, :path => "disable_selinux.sh"
        node.vm.provision 'shell', inline: 'sestatus'
        node.vm.provision :shell, :path => "prerequisite_application_install.sh"
        node.vm.provision :shell, :path => "setup_host_params.sh"
  end
  config.vm.define "spark-worker-2" do |node|
        node.vm.hostname = "spark-worker-2"
        node.vm.network :private_network, ip: "192.168.0.203"
        node.vm.provision :shell, reboot: true, :path => "disable_selinux.sh"
        node.vm.provision 'shell', inline: 'sestatus'
        node.vm.provision :shell, :path => "prerequisite_application_install.sh"
        node.vm.provision :shell, :path => "setup_host_params.sh"
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 12288
    v.cpus = 2
  end

end
