VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.define "installserver" do |installserver|
    installserver.vm.box = "debian_vanilla_7-4"
    installserver.vm.box_url = "http://os.enocloud.com:8080/v1/AUTH_045c6a86c9544e8cb5f99901faadefd4/diplo-vagrant-box/debian_vanilla_7-4.box"
    installserver.vm.provision "shell", path: "install.sh"
    installserver.vm.hostname = "installserver"
  end
end
