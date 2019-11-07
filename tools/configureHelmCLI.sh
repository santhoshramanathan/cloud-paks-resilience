MASTER_URL=https://icp-console.patrocinio6-fa9ee67c9ab6a7791435450358e564cc-0001.us-east.containers.appdomain.cloud

. ~/icp.sh

echo Configuring Helm CLI for ICP on $MASTER_URL
cloudctl login -a $MASTER_URL -u admin -p $ICP_PASSWORD -n apic \
  --skip-ssl-validation
