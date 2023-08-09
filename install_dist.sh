#!/bin/bash

# mkdir 
mkdir -p dist/rpm/docker

# cp script
cp -rf ./script/init_* ./dist
cp -rf ./script/install_* ./dist

# cp tinyscan
cp -rf ./tinyscan ./dist

# target docker/
echo "==> Extracting rpm/docker."
tar -xf ./resource/rpm_docker.tar.* --strip-components=1 -C ./dist/rpm/docker/

# target sext/
echo "==> Extracting mongo/sext."
tar -xf ./resource/mongo_sext.tar.* --strip-components=1 -C ./dist/tinyscan/mongo/rule/sext/

# target bin/
echo "==> Extracting engine/bin."
tar -xf ./resource/engine_bin.tar.* --strip-components=1 -C ./dist/tinyscan/engine/export/bin/

# target font/
echo "==> Extracting engine/font."
tar -xf ./resource/engine_font.tar.* --strip-components=1 -C ./dist/tinyscan/engine/export/font/

echo "==> Install dist done."

