# 8．	进入soclib_exp/hello_world文件夹，输入source install.sh configurations/mips运行脚本，然后输入make对软件部分进行编译

cd ~/soclib_exp/hello_world
source install.sh configurations/mips
make

# /bin/sh: line 1: exit: create_builddir: numeric argument required
# make: *** [/root/projet_soc/PLATFORM/SW_PLATFORM/APES/support/Makefile.rules:13: apes_submake] Error 2
#
# 在我向 ~/projet_soc/PLATFORM/SW_PLATFORM/APES/support/Makefile.rules 文件 13 行 `for` 前面添加了 `echo "SUBDIRS: $(SUBDIRS)";` 后，这里反而不报错了。
# 报错位置变为了
#
# o -o APP.x  /APP/*.o
# /bin/sh: line 1: /root/projet_soc/PLATFORM/SW_PLATFORM/Toolchains/mipsel-sls-dnaos.toolchain/bin/mipsel-sls-dnaos-gcc: cannot execute: required file not found
# make: *** [Makefile:56: binary] Error 127
#
# 理论上我的环境变量没有乱飘，$TARGET_LD 是正常的。我也不懂 Makefile，感觉是 Makefile 的锅，变量被清完了。