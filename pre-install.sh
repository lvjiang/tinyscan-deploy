#!/bin/bash

# target rpm_docker/
echo "==> Extracting rpm_docker."
tar -xf ./package/rpm_docker.tar.* -C .

# target sext/
echo "==> Extracting mongo_sext."
tar -xf ./package/sext.tar.* -C ./tinyscan/mongo/rule/

# target bin/
echo "==> Extracting engine_bin."
tar -xf ./package/engine_bin.tar.* -C ./tinyscan/engine/export/

# target font/
echo "==> Extracting engine_font."
tar -xf ./package/engine_font.tar.* -C ./tinyscan/engine/export/

echo "==> Pre-install done."

