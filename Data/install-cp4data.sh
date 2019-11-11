NAMESPACE=zen

DOCKER_REGISTRY="us.icr.io/release2_1_0_1_base"
DOCKER_REGISTRY_USER="patrocinio-key"
DOCKER_REGISTRY_PASS="tYwud0qMc5QZOkY7gznGe7oPKbpRhttQpTF64N3I0RGs"

oc create ns ${NAMESPACE}
oc project ${NAMESPACE}

oc create sa -n ${NAMESPACE} tiller
oc create sa -n ${NAMESPACE} icpd-anyuid-sa

# Add `deployer` serviceaccount to `system:deployer` role to allow the template kickstart
oc -n ${NAMESPACE} adm policy add-role-to-user -z deployer system:deployer

# Create the secrets to pull images from the docker repository
oc create secret docker-registry icp4d-anyuid-docker-pull -n ${NAMESPACE} --docker-server=${DOCKER_REGISTRY} --docker-username=${DOCKER_REGISTRY_USER} --docker-password=${DOCKER_REGISTRY_PASS} --docker-email=cp4data@ibm.com
oc secrets -n ${NAMESPACE} link default icp4d-anyuid-docker-pull --for=pull
oc secrets -n ${NAMESPACE} link tiller icp4d-anyuid-docker-pull --for=pull
oc secrets -n ${NAMESPACE} link icpd-anyuid-sa icp4d-anyuid-docker-pull --for=pull

# Set the Security Context -  One scc is created for every namespace
cat << EOF | oc apply -f -
allowHostDirVolumePlugin: true
allowHostIPC: true
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegedContainer: false
allowedCapabilities:
- '*'
allowedFlexVolumes: null
apiVersion: v1
defaultAddCapabilities: []
fsGroup:
  type: RunAsAny
groups:
- cluster-admins
kind: SecurityContextConstraints
metadata:
  annotations:
    kubernetes.io/description: zenuid provides all features of the restricted SCC but allows users to run with any UID and any GID.
  name: ${NAMESPACE}-zenuid
priority: 10
readOnlyRootFilesystem: false
requiredDropCapabilities: []
runAsUser:
  type: RunAsAny
seLinuxContext:
  type: MustRunAs
supplementalGroups:
  type: RunAsAny
users:
- system:serviceaccount:${NAMESPACE}:default
- system:serviceaccount:${NAMESPACE}:icpd-anyuid-sa
volumes:
- configMap
- downwardAPI
- emptyDir
- persistentVolumeClaim
- projected
- secret
EOF

# Give cluster-admin permission to the service accounts used on the installation
oc adm policy add-cluster-role-to-user cluster-admin "system:serviceaccount:${NAMESPACE}:tiller"
oc adm policy add-cluster-role-to-user cluster-admin "system:serviceaccount:${NAMESPACE}:default"
oc adm policy add-cluster-role-to-user cluster-admin "system:serviceaccount:${NAMESPACE}:icpd-anyuid-sa"

# Set the template for the catalog
cat << EOF | oc apply -f -
---
apiVersion: template.openshift.io/v1
kind: Template
message: |-
  The following service(s) have been created in your project: ${NAMESPACE}.
        Username: admin
        Password: password
        Go to the *Applications* menu and select *Routes* to view the Cloud Pak for Data URL.
  For more information about, see https://docs-icpdata.mybluemix.net/home.
metadata:
  name: cp4data
  annotations:
    description: |-
      IBM Cloud Pak for Data is a native cloud solution that enables you to put your data to work quickly and efficiently.
    openshift.io/display-name: Cloud Pak for Data
    openshift.io/documentation-url: https://docs-icpdata.mybluemix.net/home
    openshift.io/long-description: IBM Cloud Pak for Data is composed of pre-configured microservices that run on a multi-node IBM Cloud Private cluster. The microservices enable you to connect to your data sources so that you can catalog and govern, explore and profile, transform, and analyze your data from a single web application..
    openshift.io/provider-display-name: Red Hat, Inc.
    openshift.io/support-url: https://access.redhat.com
    tags: AI, Machine Learning, Data Management, IBM
objects:
- apiVersion: v1
  kind: DeploymentConfig
  metadata:
