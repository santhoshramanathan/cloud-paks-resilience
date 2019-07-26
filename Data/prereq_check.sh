WORK_DIR=/root/work_data

function cloneRepo {
  git clone https://github.com/IBM-ICP4D/icp4d-serviceability-cli.git
}

mkdir -p $WORK_DIR
cd $WORK_DIR
cloneRepo
