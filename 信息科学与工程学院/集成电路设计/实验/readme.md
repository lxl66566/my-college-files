# 实验

对于我这种实体 linux 系统很不友好。老师给的还是 vmware7，2010 的实验报告，而且年份不同，diff 的输出也不同。虚拟机内的文件也没给，只给了 vmware 镜像。。。而我是绝对不可能用 vmware 的。

我也考虑过在本机直接跑 linux 命令，但是实验运行的都是一些破坏性很强的代码（往各种目录扔垃圾），并且还都需要截图结果。因此必须使用虚拟机。

## 环境配置

### 使用 qemu

我们可以将 vmdk 转为 qcow2 镜像（加载会更快一点），然后使用 qemu 运行。

```bash
qemu-img convert -O qcow2 SoCdesign.vmdk SoCdesign.qcow2
qemu-system-x86_64 -hda SoCdesign.qcow2
```

当然这个玩意性能不太行，卡的要死，而且给的镜像在 ubuntu-desktop 里却还要纯用 terminal，实在是傻。想卸载 ubuntu-desktop，结果并不是用 apt 装的，而且版本太低了，还是 service 的时代。apt 换完镜像发现一堆内部错误装不了包，qemu 又不提供好用的剪贴板，绷。

### mkarchroot

archlinux 有 `arch-chroot` 命令，可以进入一个基本隔离的环境。因此我打算尝试一下。

```bash
sudo pacman -S devtools
mkarchroot vm base-devel vim
sudo arch-chroot vm
```

但是一进去安装不了软件，需要改一下 `/etc/pacman.conf`，将里面的 `CheckSpace` 删掉。
