# 2、	每次重新启动一次Shell控制台，均要重新运行一下步骤7中的脚本“install_env.sh”。请设计让 install_env.sh在shell控制台自动启动。（10分）


echo 'source ~/projet_soc/TP/install_env.sh' >> ~/.bashrc
source ~/.bashrc