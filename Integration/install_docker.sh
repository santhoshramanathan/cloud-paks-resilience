function installDocker {
  yum install -y docker
}

function enableDocker {
  systemctl start docker
}

#installDocker
enableDocker
