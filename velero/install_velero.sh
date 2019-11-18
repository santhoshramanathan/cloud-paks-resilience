WORK_DIR=~/work

function cloneProject {
  git clone https://github.com/vmware-tanzu/velero.git
}

function installMinIO {
  echo Installing MinIO
  oc apply -f examples/minio/00-minio-deployment.yaml
}

function exposeMinIO {
  oc expose svc minio
}

function createVeleroCredentials {
  cat << EOF > credentials-velero
[default]
aws_access_key_id = minio
aws_secret_access_key = minio123
EOF
}

function installVelero {
  echo Installing velero
  velero install \
      --provider aws \
      --bucket velero \
      --secret-file ./credentials-velero \
      --use-volume-snapshots=false \
      --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.velero.svc:9000
}

cd $WORK_DIR
#cloneProject
cd velero
#installMinIO
oc project velero
#exposeMinIO
#createVeleroCredentials
#installVelero
