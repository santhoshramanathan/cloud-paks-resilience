function uninstall {
  ansible-playbook playbooks/uninstall.yml
}

cd /usr/share/ansible/openshift-ansible
uninstall
