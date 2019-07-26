PROJECT=cp4i

echo Creating project...
oc new-project $PROJECT

echo Updating Security Context...
oc adm policy add-scc-to-user ibm-restricted-scc system:serviceaccounts:$PROJECT
