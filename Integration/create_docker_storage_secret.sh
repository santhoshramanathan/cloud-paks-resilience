kubectl create secret docker-registry apic-docker-registry \
   --docker-server=http://docker-registry.default.svc:5000/v1/ \
   --docker-username=$(oc whoami) --docker-password=$(oc whoami -t) \
  --docker-email=me@my.com

 
