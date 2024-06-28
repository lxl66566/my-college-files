# 1．	对压缩包libtool-1.5解压缩，然后安装libtool
cd /tmp
wget http://cs.e.ecust.edu.cn/download/1f5e10322adf1b1e2413e5a8409da95a -O libtool-1.5.tar.gz   # 下载 libtool 压缩包
tar xvaf libtool-1.5.tar.gz
cd libtool-1.5
./configure
make
make check              # 这一行是跑测试的，可以不要
sudo make install
