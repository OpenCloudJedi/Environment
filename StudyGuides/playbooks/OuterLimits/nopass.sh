#!/bin/bash
ansible all -u root -m copy -a 'dest=/etc/sudoers.d/student content="student ALL=(ALL) NOPASSWD: ALL"'
echo '###########################################################'
ansible all -b -m ping
