WORK_DIR=/root/work_cp4i

cd $WORK_DIR
echo Downloading Helm chart
curl -k -L https://github.com/IBM/charts/blob/master/repo/entitled/ibm-apiconnect-icp4i-prod-1.0.3.tgz > ibm-apiconnect-icp4i-prod-1.0.3.tgz
