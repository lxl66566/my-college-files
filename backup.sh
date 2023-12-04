git add -A
git status
git commit -m $(date "+%Y%m%d-%H:%M:%S")
git push gitee main &
git push origin main
wait
exec /bin/bash