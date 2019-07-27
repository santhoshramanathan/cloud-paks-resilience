export IMAGE_DIR=/images/Data
export WORK_DIR=/root/work_cp4d

function download {
  chmod +x $IMAGE_DIR/ICP4D_ENT_Req_ICP_x86_V2.1.0.1.bin

  cd $WORK_DIR
  $IMAGE_DIR/ICP4D_ENT_Req_ICP_x86_V2.1.0.1.bin
}

download
