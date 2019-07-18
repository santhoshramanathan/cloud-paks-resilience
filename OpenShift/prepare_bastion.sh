function create_ssh_key {
  ssh-keygen -t rsa -P ''
}

function copy_key {
  for m in master worker1 worker2 worker3 storage1 storage2 storage3 infra
  do
    echo Copying to $m
    ssh-copy-id -i ~/.ssh/id_rsa.pub root@$m.patrocinio.org
  done
}

function install_ansible {
  yum install -y openshift-ansible-2.5.5
}


#create_ssh_key
#copy_key
install_ansible
