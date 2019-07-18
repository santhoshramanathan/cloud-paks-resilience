function configure_credentials {
  sed "s/REDHAT_USER/$REDHAT_USER/g" < hosts > /tmp/hosts
  sed "s/REDHAT_PASSWORD/$REDHAT_PASSWORD/g" < /tmp/hosts > /etc/ansible/hosts
}

function install_prereqs {
  cd /usr/share/ansible/openshift-ansible
  ansible-playbook playbooks/prerequisites.yml
}

#configure_credentials
install_prereqs
