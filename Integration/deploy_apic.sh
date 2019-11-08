NAME=my-apic-v7
PROJECT=apic
SCC=ibm-anyuid-hostpath-scc
ACCOUNT=my-apic-v4-ibm-apiconnect-icp4i-prod
WORK_DIR=/root/work_cp4i

function deployHelm {
  cd $WORK_DIR
  echo Deploying $NAME
  helm install ibm-apiconnect-icp4i-prod --name $NAME \
    --tls --debug
}

function associateSCC {
  oc adm policy add-scc-to-user $SCC system:serviceaccount:$PROJECT:$ACCOUNT
}

#associateSCC
deployHelm
