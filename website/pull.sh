#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd ${SCRIPT_DIR}/notxia.github.io
if git status | grep -q "branch is behind"; then
    git pull
    cd ..
    docker compose up -d --build
fi