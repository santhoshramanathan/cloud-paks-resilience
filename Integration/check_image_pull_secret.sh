function dockerLogin {
  docker login cp.icr.io -u cp -p $ENTITLEMENT_KEY
}

dockerLogin
docker pull my-appc-v4-ibm-ace-dashboard-icp4i-prod-secret-gen-q6hd2
