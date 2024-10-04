#!/usr/bin/env bash

set -euxo pipefail

git-se e
git add -A
git commit --allow-empty-message -m "$*"
git push origin main
git push gitee main