function uninstall {
  ansible-playbook playbooks/adhoc/uninstall.yml
}

cd /usr/share/ansible/openshift-ansible
uninstall
