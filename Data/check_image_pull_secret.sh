function dockerLogin {
  docker login cp.icr.io -u ekey -p $ENTITLEMENT_KEY
}

ENTITLEMENT_KEY=$(pak-entitlement.sh show-key Data)
echo Key: $ENTITLEMENT_KEY

dockerLogin
docker pull cp.stg.icr.io/cp/cp4d/cp4d-installer:v1.4
