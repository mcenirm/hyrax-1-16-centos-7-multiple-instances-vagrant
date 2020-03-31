# hyrax-1-16-centos-7-multiple-instances-vagrant

Goal: Run multiple instances of hyrax using systemd template units

Secondary goal: Demonstrate upgrade from 1.13 to 1.16

## Steps

1. Edit [Vagrantfile](Vagrantfile), changing `instances` elements as needed
1. Boot the VM and provision tomcat instances with `vagrant up`
1. SSH to the VM with `vagrant ssh`
1. Change to the playbook directory with `cd /vagrant`
1. Install Hyrax 1.13 with `./run_playbook.sh playbook-install-hyrax-1-13.yml`
1. Verify hyrax works with http://localhost:8030/opendap/csv/temperature.csv.html (change port to match Vagrantfile)
1. Upgrade to Hyrax 1.16 with `./run_playbook.sh playbook-upgrade-to-hyrax-1-16.yml`
1. Verify with _TODO_

## Misc notes

* After changing the instances list in Vagrantfile:
  1. Run `vagrant validate`
  1. Restart the VM with `vagrant halt` followed by `vagrant up`
  * Note: Anything removed from the instances list will not remove tomcat/bes instances already in the VM.
* After changing [playbook-tomcats.yml](playbook-tomcats.yml), run `vagrant provision`.

## Problems

* olfs 1.18.3 (hyrax 1.15.3) [no longer looks at the OLFS_CONFIG_DIR environment variable](https://github.com/OPENDAP/olfs/commit/cfe7dcc47de63235cefe94e14472190bf8c10e00), but [the hyrax guide was not updated to match](https://opendap.github.io/hyrax_guide/Master_Hyrax_Guide.html#OLFS-config-location) (as of Version 1.0,
2019-06-21). Instead it will only use the first readable and writable directory from a static list:
  1. `/etc/olfs/` - Prevents multiple instances on the same host
  1. `/usr/share/olfs/` - Prevents multiple instances on the same host
  1. `.../webapps/opendap/WEB-INF/conf/` - Gets overwritten with new deployment of `opendap.war`.

  Note also that the last one requires `<Host ... unpackWARs="true" ...>` in tomcat's `server.xml`, because the still-packed war file is never writable. As far as I can tell, the only reliable way to support multiple instances is to customize `opendap.war` with the necessary changes to the files under `WEB-INF/conf/`.

  Ideally, these sorts of details would be handled using a [context definition](https://tomcat.apache.org/tomcat-9.0-doc/config/context.html#Defining_a_context) as part of deploying the webapp, and not environment variables (at least not directly) or hard-coded locations.

* The selinux-policy-targeted package includes rules supporting multiple instances using the tomcat package (ie, `tomcat@NAME.service` and `/var/lib/tomcats/NAME/`). Any deviation from this requires adjustments to the policies, such as using `semanage fcontext`.
