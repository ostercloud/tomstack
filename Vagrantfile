# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "centos" do |centos|
    centos.vm.box = "centos65"
    centos.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"
    centos.omnibus.chef_version = :latest
    centos.vm.network :private_network, ip: "192.168.254.10"
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu-1204"
    ubuntu.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"
    ubuntu.omnibus.chef_version = :latest
    ubuntu.vm.network :private_network, ip: "192.168.254.12"
  end


  config.vm.boot_timeout = 120
  config.berkshelf.enabled = true
  config.vm.network "forwarded_port", guest: 8080, host: 8081
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision :chef_solo do |chef|

    chef.json = {
        "apache" => {
            "contact" => "ops@example.com",
            "sites" => {
            }
        },
        "tomcat" => {
          "apps" => {
            "ROOT" => {
              "warfile" => {
                "url" => "http://1518c556ba154ede3719-c95ab40bfe852544a8b5444ad1e4a375.r17.cf5.rackcdn.com/javaTestApp-JDK6-v.0.2.war"
              }
            }
          }
        },
        "holland" => { "enabled" => "false" }
    }

    chef.run_list = [
      "recipe[tomstack::mysql_master]",
      "recipe[tomstack]"
    ]
  end
end
