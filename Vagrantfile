# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7"

  instances = [
    {
      :shortname => "demodev",
      :path_to_data_tree => "/srv/demodev/data",
      :tomcat => {
        :shutdown_port => 8010,
        :ajp_port => 8020,
        :http_port => 8030,
      },
      :bes => {
        :server_port => 10020,
      },
    },
  ]

  instances.each do |instance|
    port = instance[:tomcat][:http_port]
    config.vm.network "forwarded_port", guest: port, host: port
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "playbook-tomcats.yml"
    ansible.extra_vars = {
      :instances => instances,
    }
  end
end
