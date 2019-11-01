SECRET=apic-docker-registry

echo Deleting secret $SECRET
kubectl delete secret $SECRET

echo Creating secret $SECRET
kubectl create secret docker-registry $SECRET \
   --docker-server=http://docker-registry.default.svc:5000/v1/ \
   --docker-username=cp --docker-password=$(oc whoami -t \
  --docker-email=me@my.com
