function cpe_logstore {
  oc delete -f cpe-logstore-pvc.yaml
  oc apply -f cpe-logstore-pv.yaml
  oc apply -f cpe-logstore-pvc.yaml
}

function cpe_filestore {
  oc delete -f cpe-filestore-pvc.yaml
  oc apply -f cpe-filestore-pv.yaml
  oc apply -f cpe-filestore-pvc.yaml
}

function cpe_bootstrap {
  oc delete -f cpe-bootstrap-pvc.yaml
  oc apply -f cpe-bootstrap-pv.yaml
  oc apply -f cpe-bootstrap-pvc.yaml
}

function cpe_textext {
  oc delete -f cpe-textext-pvc.yaml
  oc apply -f cpe-textext-pv.yaml
  oc apply -f cpe-textext-pvc.yaml
}

function cpe_icmrules {
  oc delete -f cpe-icmrules-pvc.yaml
  oc apply -f cpe-icmrules-pv.yaml
  oc apply -f cpe-icmrules-pvc.yaml
}

function css_cfgstore {
  oc delete -f css-cfgstore-pvc.yaml
  oc apply -f css-cfgstore-pv.yaml
  oc apply -f css-cfgstore-pvc.yaml
}

function css_tempstore {
  oc delete -f css-tempstore-pvc.yaml
  oc apply -f css-tempstore-pv.yaml
  oc apply -f css-tempstore-pvc.yaml
}

function css_logstore {
  oc delete -f css-logstore-pvc.yaml
  oc apply -f css-logstore-pv.yaml
  oc apply -f css-logstore-pvc.yaml
}

function css_indexstore {
  oc delete -f css-indexstore-pvc.yaml
  oc apply -f css-indexstore-pv.yaml
  oc apply -f css-indexstore-pvc.yaml
}

function css_icp_customstore {
  oc delete -f css-icp-customstore-pvc.yaml
  oc apply -f css-icp-customstore-pv.yaml
  oc apply -f css-icp-customstore-pvc.yaml
}

function cmis_cfgstore {
  oc delete -f cmis-cfgstore-pvc.yaml
  oc apply -f cmis-cfgstore-pv.yaml
  oc apply -f cmis-cfgstore-pvc.yaml
}

function cmis_logstore {
  oc delete -f cmis-logstore-pvc.yaml
  oc apply -f cmis-logstore-pv.yaml
  oc apply -f cmis-logstore-pvc.yaml
}

oc delete -f cpe-cfgstore-pvc.yaml
oc apply -f cpe-cfgstore-pv.yaml
oc apply -f cpe-cfgstore-pvc.yaml

#cpe_logstore
#cpe_filestore
#cpe_bootstrap
#cpe_textext
#cpe_icmrules
#css_cfgstore
#css_tempstore
#css_logstore
#css_indexstore
#css_icp_customstore
#cmis_cfgstore
#cmis_logstore
