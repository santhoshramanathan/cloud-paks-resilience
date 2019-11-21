function dockerLogin {
  docker login cp.icr.io -u ekey -p $ENTITLEMENT_KEY
}

ENTITLEMENT_KEY=$(pak-entitlement.sh show-key Integration)
echo Key: $ENTITLEMENT_KEY

dockerLogin
docker pull cp.icr.io/cp/icp4i/ace/ibm-ace-icp-configurator-prod:11.0.0.6-amd64
