NAME=$1
PROJECT=apic2
SCC=ibm-anyuid-hostpath-scc
ACCOUNT=my-apic-v4-ibm-apiconnect-icp4i-prod
WORK_DIR=/root/work_cp4i

function deployHelm {
  echo Deploying $NAME
  helm install https://github.com/IBM/charts/raw/master/repo/entitled/ibm-apiconnect-icp4i-prod-1.0.3.tgz \
    --name $NAME --tls --debug -f values.yaml 
}

function associateSCC {
  oc adm policy add-scc-to-user $SCC system:serviceaccount:$PROJECT:$ACCOUNT
}

#associateSCC
deployHelm
