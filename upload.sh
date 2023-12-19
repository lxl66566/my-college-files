git add -A
git status
git commit -m $(date "+%Y%m%d-%H:%M:%S")
git push origin main
git push gitee main
exec /bin/bash