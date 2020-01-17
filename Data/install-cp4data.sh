#!/bin/bash
#******************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2019. All Rights Reserved.
#
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#******************************************************************************

if [[ -z $1 ]]; then
    echo "Usage: ./install-cp4data.sh <<namespace>>"
    exit 1
fi

NAMESPACE=$1
# Change the values below to match with your repository information
DOCKER_REGISTRY="cp.icr.io/cp/cp4d"
DOCKER_REGISTRY_USER="ekey"
DOCKER_REGISTRY_PASS="27vwdif4IWJxOSA6sqDSTsABO9nEPwu574SRas-5utkz"

oc create ns ${NAMESPACE}

oc project ${NAMESPACE}

oc create sa -n ${NAMESPACE} default
oc create sa -n ${NAMESPACE} tiller

# Add `deployer` serviceaccount to `system:deployer` role to allow the template kickstart
oc -n ${NAMESPACE} adm policy add-role-to-user -z deployer system:deployer

# Create the secrets to pull images from the docker repository
oc create secret docker-registry icp4d-anyuid-docker-pull -n ${NAMESPACE} --docker-server=${DOCKER_REGISTRY} --docker-username=${DOCKER_REGISTRY_USER} --docker-password=${DOCKER_REGISTRY_PASS} --docker-email=cp4data@ibm.com
oc secrets -n ${NAMESPACE} link default icp4d-anyuid-docker-pull --for=pull


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


# Set the template for the catalog
cat << EOF | oc apply -f -
---
apiVersion: template.openshift.io/v1
kind: Template
message: |-
  The following service(s) have been created in your project: ${NAMESPACE}.

        Username: admin
        Password: password

  For more information about, see https://docs-icpdata.mybluemix.net/home.
metadata:
  name: cp4data
  annotations:
    description: |-
      IBM® Cloud Pak for Data is a native cloud solution that enables you to put your data to work quickly and efficiently.
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
    name: cp4data-installer
    annotations:
      template.alpha.openshift.io/wait-for-ready: "true"
  spec:
    replicas: 1
    selector:
      name: cp4data-installer
    strategy:
      type: Recreate
    template:
      metadata:
        labels:
          name: cp4data-installer
      spec:
        containers:
        - env:
          - name: NAMESPACE
            value: \${NAMESPACE}
          - name: TILLER_NAMESPACE
            value: \${NAMESPACE}
          - name: INSTALL_TILLER
            value: "1"
          - name: TILLER_IMAGE
            value: "${DOCKER_REGISTRY}/cp4d-tiller:v1"
          - name: TILLER_TLS
            value: "0"
          - name: STORAGE_CLASS
            value: \${STORAGE_CLASS}
          - name: DOCKER_REGISTRY
            value: ${DOCKER_REGISTRY}
          - name: DOCKER_REGISTRY_USER
            value: ${DOCKER_REGISTRY_USER}
          - name: DOCKER_REGISTRY_PASS
            value: \${DOCKER_REGISTRY_PASS}
          - name: CONSOLE_ROUTE_PREFIX
            value: \${CONSOLE_ROUTE_PREFIX}
          - name: CONSOLE_PASSWORD
            value: \${CONSOLE_PASSWORD}
          name: cp4data-installer
          image: "${DOCKER_REGISTRY}/cp4d-installer:v1.4"
          imagePullPolicy: Always
          resources:
            limits:
              memory: "200Mi"
              cpu: 1
          command: [ "/bin/sh", "-c" ]
          args: [ "./deploy-cp4data.sh; sleep 3000000" ]
        imagePullSecrets:
        - name: icp4d-anyuid-docker-pull
parameters:
- description: Namespace where to install Cloud Pak for Data.
  displayName: Namespace
  name: NAMESPACE
  required: true
  value: ${NAMESPACE}
- description: Docker registry user with permission with pull images.
  displayName: Docker Registry User
  name: DOCKER_REGISTRY_USER
  value: ${DOCKER_REGISTRY_USER}
  required: true
- description: Docker registry password.
  displayName: Docker Registry Password
  name: DOCKER_REGISTRY_PASS
  required: true
  value: ${DOCKER_REGISTRY_PASS}
- description: Hostname for the external route.
  displayName: Cloud Pak route hostname
  name: CONSOLE_ROUTE_PREFIX
  required: true
  value: "cp4data-console"
- description: Storage class name.
  displayName: StorageClass
  name: STORAGE_CLASS
  value: "glusterfs-storage"
  required: true
- description: This password can be changed after login on the CP4Data console
  displayName: Console Password
  name: CONSOLE_PASSWORD
  value: "password"
  required: true

EOF
