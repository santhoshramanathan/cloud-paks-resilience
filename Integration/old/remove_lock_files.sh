WORK_DIR=/root/work_cp4i
INSTALLER_FILES_DIR=$WORK_DIR/installer_files/cluster

cd $INSTALLER_FILES_DIR
rm .openshift-images-uploaded-3.2.0.1907.lock
cd icp4icontent
rm -f *.lock
