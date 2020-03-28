#!/bin/bash
set -eu
ansible-playbook -i /tmp/vagrant-ansible/inventory "$@"
