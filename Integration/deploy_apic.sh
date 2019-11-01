#NAME=$1
PROJECT=apic
SCC=ibm-anyuid-hostpath-scc
ACCOUNT=my-apic-v2-ibm-apiconnect-icp4i-prod

#echo Deploying $NAME
#helm install ibm-apiconnect-icp4i-prod-1.0.2 --name $NAME --values apic.yaml

function associateSCC {
  oc adm policy add-scc-to-user $SCC system:serviceaccount:$PROJECT:$ACCOUNT
}

associateSCC
