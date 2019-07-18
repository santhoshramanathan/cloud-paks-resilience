function create_ssh_key {
  ssh-keygen -t rsa -P ''
}

function copy_key {
  for m in master worker1 worker2 worker3 storage storage2 storage3 infra
  do
    echo Copying to $m
    ssh-copy-id -i ~/.ssh/id_rsa.pub root@$m.patrocinio.org
  done
}

#create_ssh_key
copy_key
