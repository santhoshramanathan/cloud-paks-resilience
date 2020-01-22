for i in {1..30}
do
  echo Creating PV $i
  sed s/NAME/\"$i\"/g pvc-template.yaml > /tmp/pvc.yaml
  oc delete pvc $i
  oc apply -f /tmp/pvc.yaml
done
