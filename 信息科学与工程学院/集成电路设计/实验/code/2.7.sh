# 7．	打开Shell控制台，进入projet/TP文件夹，输入source install_env.sh设置系统环境变量

sed -i 's|/softslin/projet_soc|$SOCLIB_DIR|g' ~/projet_soc/TP/install_env.sh    # 默认给的 install_env.sh 有问题，需要替换路径。
source ~/projet_soc/TP/install_env.sh

# 我们也可以把最后一行 source 写入 ~/.bashrc，这样每次进入终端都会自动 source 好，做好编译准备