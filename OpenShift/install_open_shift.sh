function register_host {
  subscription-manager refresh
}

function find_pool_ID {
  POOL_ID=2c9a01226880d2d50168811685070bcf
}

function attach_pool_ID {
  subscription-manager attach --pool=$POOL_ID
}

function disable_yum_repos {
  subscription-manager repos --disable="*"
}

function enable_OpenShift_repo {
  subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.11-rpms" \
    --enable="rhel-7-server-ansible-2.6-rpms"
}

#register_host
#find_pool_ID
#attach_pool_ID
#disable_yum_repos
enable_OpenShift_repo
