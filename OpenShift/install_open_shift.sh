function register_host {
  subscription-manager refresh
}

function find_pool_ID {
  subscription-manager list --available --matches '*OpenShift*'
}

register_host
find_pool_ID
