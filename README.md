# hyrax-1-16-centos-7-multiple-instances-vagrant

Goal: Run multiple instances of hyrax using systemd template units

Secondary goal: Demonstrate upgrade from 1.13 to 1.16

1. Edit [Vagrantfile](Vagrantfile), changing `instances` elements as needed
1. Boot the VM and provision tomcat instances with `vagrant up`
1. SSH to the VM with `vagrant ssh`
1. Change to the playbook directory with `cd /vagrant`
1. Install Hyrax 1.13 with `./run_playbook.sh playbook-install-hyrax-1-13.yml`
1. Verify hyrax works with http://localhost:8030/opendap/csv/temperature.csv.html (change port to match Vagrantfile)
1. Upgrade to Hyrax 1.16 with `./run_playbook.sh playbook-upgrade-to-hyrax-1-16.yml`
1. Verify with _TODO_

Misc notes

* After changing the instances list in Vagrantfile:
  1. Run `vagrant validate`
  1. Restart the VM with `vagrant halt` followed by `vagrant up`
  * Note: Anything removed from the instances list will not remove tomcat/bes instances already in the VM.
* After changing [playbook-tomcats.yml](playbook-tomcats.yml), run `vagrant provision`.
