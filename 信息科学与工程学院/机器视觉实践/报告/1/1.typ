#import "../template.typ": *

#show: project.with(
  title: "1",
  authors: ("absolutex",),
)

= 机器视觉实践 一

== 实验目的

图像划痕修复：

+ 编程实现图像划痕修复
+ 要求算法具有一定实时性能够处理较密集的图像划痕
+ 具体实现方法不限
+ 编程语言不限，可通过C++,Python或Matlab实现

== 实验内容

=== 高斯模糊

课上有学习过，高斯模糊是一种平滑滤波器，它通过在图像的每个像素周围应用加权平均来减少图像中的高频噪声和细节。这种模糊操作会丢失图像中的细节信息，包括瑕疵的边缘和纹理。所以我尝试用高斯模糊来实现图像划痕去除。

#include_code("../src/scratch/gause.py")

=== inpaint

当然，使用 inpaint 是更广泛使用的方式。inpaint 需要一张 mask，在划痕部分为白色，而在其他地方为黑色。这个 mask 对于修复划痕是必要的。

但是从图像自动生成 mask 非常困难，业界一般使用大模型去生成 mask。这里就让用户自行画出 mask。这里我使用 python tkinter 库，将图片显示到窗口上，而实际作画时同时在图片和准备好的蒙版上进行绘制，并将最终结果保存为图片。

#include_code("../src/scratch/drawmaskw.py")

然后，将蒙版与原始图像同时输入到 inpaint，得到修复后的图像。


#include_code("../src/scratch/myinpaint.py")

这里使用了 opencv 库中的 inpaint 方法。OpenCV 提供了两种主要的修复算法：Telea 方法（基于快速行进算法），Navier-Stokes 方法（基于流体力学方程）。

Telea 方法基于快速行进算法（Fast Marching Method, FMM），它通过逐步扩展修复区域来填充缺失部分。该方法的核心思想是：对于每个需要修复的像素，使用其周围已知像素的加权平均值来估计其颜色值。权重取决于像素到已知区域的距离。

Navier-Stokes 方法基于流体力学中的 Navier-Stokes 方程，通过模拟流体的运动来填充缺失区域。该方法的核心思想是：将图像视为一个流体场，通过求解流体力学方程来模拟流体的运动，从而填充缺失区域。

== 实验结果

=== 高斯模糊

#figure(
  image("gause.jpg", width: 100%),
  caption: [gause 效果图],
)

可以看出高斯模糊的效果并不好，处理后图像还是能看见明显的划痕，这可能是没选择好高斯核（ksize）的大小导致的。但是 ksize 大了容易丢失其他高频细节，因此需要做好权衡。

=== inpaint

#figure(
  image("mask.jpg", width: 50%),
  caption: [用户绘制的 mask],
)

#figure(
  image("inpaint.jpg", width: 100%),
  caption: [inpaint 效果图（Telea）],
)

可以看出，inpaint 的效果不错。虽然在划痕边缘出现了色块扭曲等现象，这可能是因为用户绘制的 mask 覆盖了更多的色块导致的。如果使用更加细致精确的 mask，可以产生更好的效果。

至于 Telea 方法和 Navier-Stokes 方法我也都尝试了一遍，没有太大的差异。

== 心得体会

这次实践让我得以将课上的理论应用于实际。在查找方法与尝试方法的过程中我学到了很多理论无法教给我的东西。并且此过程中我也顺带学习了 python 项目管理，tkinter GUI 的绘制，蒙版的制作等。
