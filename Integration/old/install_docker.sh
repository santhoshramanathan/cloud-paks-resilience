DEVICE=/dev/xvdc

function installDocker {
  yum install -y docker
}

function enableDocker {
  systemctl start docker
}

function reconfigureDockerStorage {
  cat > /etc/sysconfig/docker-storage-setup << EOF
STORAGE_DRIVER=overlay2
DEVS=$DEVICE
VG=docker_vg
EOF
  rm /etc/sysconfig/docker-storage

  wipefs --all --force $DEVICE
  vgremove docker_vg

  systemctl restart docker-storage-setup
  systemctl status docker-storage-setup
  systemctl restart docker


}



#installDocker
#enableDocker
reconfigureDockerStorage
