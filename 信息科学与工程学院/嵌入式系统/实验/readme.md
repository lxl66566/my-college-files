# 嵌入式系统实验

<!-- emmm，这个实验连实验报告都没有，也不用自己写代码，只要改代码即可，非常水。 -->

## 开发环境安装

<!-- prettier-ignore -->
1. [下载资料](https://cs.e.ecust.edu.cn/download/5a403808a967b666b1e9ce9ac88429b5)并解压。
   - 约 2GB，课前提前下载。
2. 前往 _软件资料 - 软件 - MDK5_，双击 `MDK521A.exe` 安装。注意安装路径不能有中文。
3. **双击** 同文件夹下的 `Keil.STM32F4xx_DFP.2.9.0.pack` 安装。
4. 返回 _软件_，选择 _ST LINK 驱动及教程 - ST-LINK 驱动 - dpinst\_amd64.exe_，双击安装。
5. 打开桌面上的 `Keil ...` 软件，选择左上角 `File - License Management`，复制右边的 CID。
6. 下载[破解软件](https://cs.e.ecust.edu.cn/download/3b4d80b99923984b0d52f1788b5359bc)，解压运行（可能报毒，需要关闭 Windows Defender）。
7. 粘贴刚才复制的 CID，右边 Target 选择 ARM，点击 Generate，复制生成的代码。
8. 在 `Keil` 的 `License Management` 中，`New License ID code` 处粘贴代码，选择 _Add LIC_。
9. 回到 `1.` 中的资料，进入 _程序源码_，解压`1，标准例程-寄存器版本`，在 _实验 1 跑马灯实验 - USER_ 中打开 `TEST.uvprojx`。
10. 连接开发板，按 `F7` 编译，再按 `F8` download。
11. 此时应能看到开发板的 LED 闪烁。若无反应，可以按一下板子的 RESET 再观察。
