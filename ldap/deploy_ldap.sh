oc project automation

export TILLER_NAMESPACE=tiller

oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"

helm --tiller-namespace tiller delete --purge my-ldap
helm --tiller-namespace tiller install --name my-ldap stable/openldap
