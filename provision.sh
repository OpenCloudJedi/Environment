#!/bin/bash
printf "%s" "waiting for Server1 ..."
while ! timeout 0.2 ping -c 1 -n 192.168.2.3 &> /dev/null
do
    printf "%c" "."
done
printf "\n%s\n"  "Server1 is back online"
ansible-playbook -i /vagrant/inventory /vagrant/playbooks/master.yml
