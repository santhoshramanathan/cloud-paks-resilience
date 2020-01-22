#oc delete -f cpe-cfgstore-pvc.yaml
oc apply -f cpe-cfgstore-pv.yaml
oc apply -f cpe-cfgstore-pvc.yaml

#oc delete -f cpe-logstore-pvc.yaml
oc apply -f cpe-logstore-pv.yaml
oc apply -f cpe-logstore-pvc.yaml

oc apply -f cpe-filestore-pv.yaml
oc apply -f cpe-filestore-pvc.yaml

oc apply -f cpe-bootstrap-pv.yaml
oc apply -f cpe-bootstrap-pvc.yaml

oc apply -f cpe-textext-pv.yaml
oc apply -f cpe-textext-pvc.yaml

oc apply -f cpe-icmrules-pv.yaml
oc apply -f cpe-icmrules-pvc.yaml

oc apply -f css-cfgstore-pv.yaml
oc apply -f css-cfgstore-pvc.yaml

oc apply -f css-tempstore-pv.yaml
oc apply -f css-tempstore-pvc.yaml

oc apply -f css-logstore-pv.yaml
oc apply -f css-logstore-pvc.yaml

oc apply -f css-indexstore-pv.yaml
oc apply -f css-indexstore-pvc.yaml

oc apply -f css-icp-customstore-pv.yaml
oc apply -f css-icp-customstore-pvc.yaml

oc apply -f cmis-cfgstore-pv.yaml
oc apply -f cmis-cfgstore-pvc.yaml

oc apply -f cmis-logstore-pvc.yaml
