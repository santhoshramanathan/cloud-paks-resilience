function register_host {
  subscription-manager refresh
}

function find_pool_ID {
  POOL_ID=2c9a01226880d2d50168811685400be5
}

function attach_pool_ID {
  subscription-manager attach --pool=$POOL_ID
}

function disable_yum_repos {
  subscription-manager repos --disable="*"
}

#register_host
#find_pool_ID
#attach_pool_ID
disable_yum_repos
