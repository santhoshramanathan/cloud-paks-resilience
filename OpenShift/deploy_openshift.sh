function configure_credentials {
  sed "s/REDHAT_USER/$REDHAT_USER/g" < hosts > /tmp/hosts
  sed "s/REDHAT_PASSWORD/$REDHAT_PASSWORD/g" < /tmp/hosts > /etc/ansible/hosts
}

function install_prereqs {
  ansible-playbook playbooks/prerequisites.yml
}

function deploy_cluster {
  ansible-playbook playbooks/deploy_cluster.yml 2>&1 | tee /tmp/deploy.log
}

configure_credentials
cd /usr/share/ansible/openshift-ansible
#install_prereqs
deploy_cluster
