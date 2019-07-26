PROJECT=cp4i
SCC=ibm-privileged-scc

echo Creating project...
oc new-project $PROJECT

echo Updating Security Context...
oc adm policy add-scc-to-user $SCC system:serviceaccounts:$PROJECT
