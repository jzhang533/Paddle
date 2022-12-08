#!/bin/bash

# Copyright (c) 2022 PaddlePaddle Authors. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
cmake -S . -B build -DPY_VERSION=3.9 -DWITH_GPU=OFF -DWITH_TESTING=OFF -DWITH_AVX=OFF -DWITH_ARM=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build -j $(sysctl -n hw.ncpu)
"

echo -e "${YELLOW}# compile instructions using Ninja${NC}
cmake -S . -B build-ninja -GNinja -DPY_VERSION=3.9 -DWITH_GPU=OFF -DWITH_TESTING=OFF -DWITH_AVX=OFF -DWITH_ARM=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build-ninja
"

VERSION=$(date "+%Y.%m.%d")

echo -e "${YELLOW}# to specify a verison number in the built package${NC}
export PADDLE_VERSION=$VERSION
"
