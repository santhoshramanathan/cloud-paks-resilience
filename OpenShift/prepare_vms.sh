export POOL_ID=2c9a01226880d2d50168811685070bcf

function install_subscriptions {
  subscription-manager repos --disable="*"
  subscription-manager refresh
  subscription-manager attach --pool=$POOL_ID
}

function enable_yum_repos {
  subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.11-rpms" --enable="rhel-7-server-ansible-2.6-rpms" --enable="rh-gluster-3-client-for-rhel-7-server-rpms"
yum update -y
}

install_subscriptions
enable_yum_repos
