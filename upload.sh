#!/usr/bin/env bash

set -euxo pipefail

git add -A
git commit -m "update"
git push origin main
git push gitee main