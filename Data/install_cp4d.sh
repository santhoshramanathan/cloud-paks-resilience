export IMAGE_DIR=/images/Data/2.1.0.2
export WORK_DIR=/root/work_cp4d
export TILLER_NAMESPACE=tiller
export IMAGE_NAME=ICP4D_CNE_INC_ICP_x86_V2.1.0.2.bin

function download {
  chmod +x $IMAGE_DIR/$IMAGE_NAME

  cd $WORK_DIR
  yes | $IMAGE_DIR/$IMAGE_NAME --accept --nox11
}

# Deprecated
function createProject {
  oc new-project zen
}

function applySCC {
  oc create -f - << EOF
  allowHostDirVolumePlugin: false
  allowHostIPC: true
  allowHostNetwork: false
  allowHostPID: false
  allowHostPorts: false
  allowPrivilegedContainer: false
  allowedCapabilities:
  - '*'
  allowedFlexVolumes: null
  apiVersion: v1
  defaultAddCapabilities: null
  fsGroup:
    type: RunAsAny
  groups:
  - cluster-admins
  kind: SecurityContextConstraints
  metadata:
    annotations:
      kubernetes.io/description: zenuid provides all features of the restricted SCC but allows users to run with any UID and any GID.
    name: zenuid
  priority: 10
  readOnlyRootFilesystem: false
  requiredDropCapabilities: null
  runAsUser:
    type: RunAsAny
  seLinuxContext:
    type: MustRunAs
  supplementalGroups:
    type: RunAsAny
  users: []
  volumes:
  - configMap
  - downwardAPI
  - emptyDir
  - persistentVolumeClaim
  - projected
  - secret
EOF
  oc adm policy add-scc-to-user zenuid system:serviceaccount:zen:default
}

# Deprecated
function createCRB {
  kubectl create clusterrolebinding admin-on-zen --clusterrole=admin --user=system:serviceaccount:zen:default  -n zen
}

# Deprecated
function grantClusterAdminRole {
  oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:$TILLER_NAMESPACE:tiller
}

function loginToDocker {
  echo Logging to Docker
  docker login -u openshift -p $(oc whoami -t) docker-registry.default.svc:5000
}

function updateHost {
  echo Updating host
  echo 127.0.0.1 docker-registry.default.svc localhost > /etc/hosts
}

function configureAccessToRegistry {
  echo Setting port forward
  kubectl port-forward svc/docker-registry 5000 -n default &
  sleep 2
}


#applySCC
updateHost
configureAccessToRegistry
loginToDocker
#grantClusterAdminRole
#download
#createProject
