export POOL_ID=2c9a01226880d2d50168811685070bcf

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

function install_subscriptions {
  subscription-manager repos --disable="*"
  subscription-manager refresh
  subscription-manager attach --pool=$POOL_ID
}

function enable_yum_repos {
  subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.11-rpms" --enable="rhel-7-server-ansible-2.6-rpms" --enable="rh-gluster-3-client-for-rhel-7-server-rpms"
yum update -y
}

create_ssh_key
copy_key
install_subscriptions
enable_yum_repos
