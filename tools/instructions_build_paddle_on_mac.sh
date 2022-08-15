#!/bin/bash
#set -ex

YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}# instructions on build paddle on your mac M1/M2 silicon.
# please dont use mac built-in python
# to install python${NC}
brew install python
"

PYTHONLIB_PATH=$(find "$(which python3|xargs dirname)/.." -name libpython3.*|tail -1)
PYTHONLIB_DIR=$(cd $(dirname $PYTHONLIB_PATH); pwd)
PYTHONINCLUDE_DIR=$(cd $(dirname $PYTHONLIB_PATH)/../include/python*; pwd)
PYTHONBIN_DIR=$(cd $(dirname $PYTHONLIB_PATH)/../bin; pwd)
PYTHONLD_DIR=$(cd $(dirname $PYTHONLIB_PATH)/../; pwd)


echo -e "${YELLOW}# to setup python related environment${NC}
export PYTHON_LIBRARY=$PYTHONLIB_DIR
export PYTHON_INCLUDE_DIRS=$PYTHONINCLUDE_DIR
export PATH=$PYTHONBIN_DIR:\$PATH
export LD_LIBRARY_PATH=$PYTHONLD_DIR
export LD_LIBRARY_PATH=$PYTHONLD_DIR
"

echo -e "${YELLOW}# to use a homebrew installed openblas${NC}
brew install openblas
export OPENBLAS_ROOT=/opt/homebrew/opt/openblas/
"

echo -e "${YELLOW}# compile instructions${NC}
mkdir build
cd build
cmake .. -DPY_VERSION=3.9 -DWITH_GPU=OFF -DWITH_TESTING=OFF -DWITH_AVX=OFF -DWITH_ARM=ON -DCMAKE_BUILD_TYPE=Release
make TARGET=ARMV8 -j4
"
VERSION=$(date "+%Y.%m.%d")

echo -e "${YELLOW}# to specify a verison number in the built package${NC}
export PADDLE_VERSION=$VERSION
"
