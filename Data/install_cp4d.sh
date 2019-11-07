export IMAGE_DIR=/images/Data
export WORK_DIR=/root/work_cp4d
export TILLER_NAMESPACE=tiller

# Deprecated
function download {
  chmod +x $IMAGE_DIR/ICP4D_ENT_Req_ICP_x86_V2.1.0.1.bin

  cd $WORK_DIR
  $IMAGE_DIR/ICP4D_ENT_Req_ICP_x86_V2.1.0.1.bin --accept
}

# Deprecated
function createProject {
  oc new-project zen
}

# Deprecated
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
  oc adm policy add-scc-to-user anyuid system:serviceaccount:zen:icpd-anyuid-sa
}

# Deprecated
function createCRB {
  kubectl create clusterrolebinding admin-on-zen --clusterrole=admin --user=system:serviceaccount:zen:default  -n zen
}

function grantClusterAdminRole {
  oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:tiller-namespace:tiller
}

grantClusterAdminRole
#download
#createProject
#applySCC
