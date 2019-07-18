sed "s/REDHAT_USER/$REDHAT_USER/g" < hosts > /tmp/hosts
sed "s/REDHAT_PASSWORD/$REDHAT_PASSWORD/g" < /tmp/hosts > /etc/ansible/hosts 
