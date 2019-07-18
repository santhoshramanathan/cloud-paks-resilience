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

function install_packages {
  yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct glusterfs-fuse
}

function install_docker {
  yum install -y docker-1.13.1
}

function configure_docker_storage {
  cat > /etc/sysconfig/docker-storage-setup <<EOF
STORAGE_DRIVER=overlay2
DEVS=/dev/xvdb
CONTAINER_ROOT_LV_NAME=dockerlv
CONTAINER_ROOT_LV_SIZE=100%FREE
CONTAINER_ROOT_LV_MOUNT_PATH=/var/lib/docker
VG=dockervg
EOF

  wipefs --all --force /dev/xvdb
  docker-storage-setup
}

function stop_docker {
  systemctl stop docker
}

function start_docker {
  systemctl daemon-reload
  systemctl enable docker
  systemctl start docker
}

install_subscriptions
enable_yum_repos
install_packages
install_docker
stop_docker
configure_docker_storage
start_docker
