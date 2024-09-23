#import "../template.typ": *

#show: project.with(
  title: "4",
  authors: ("absolutex",),
)

= 机器视觉实践 四

== 实验目的

图像补光算法与界面设计
+ 实现图像补光算法（增加局部图像亮度，保持对比度，避免失真）
+ 设计图像补光界面，从左到右补光图像逐步替换原图像的可视化效果。

== 实验代码

这是一份单文件 html 代码，使用时需要在本地启动一个 http server.

#include_code("../src/brightness/index.html")

具体的原理是定义了三个补光因子，分别对应暗部，中间色调，亮部。对每个像素的每个 RGB 进行遍历，并将其乘以对应的补光因子。

界面设计就直接调用前端的 img-comparison-slider 库，实现了可拖拽的亮暗对比。

== 实验结果与心得体会

#figure(
  image("result.png", width: 100%),
  caption: [补光界面 效果图],
)


可以看出补光效果较好，特别是对白色背景的物体有着巨大提升。不过对于本身是黑色的物体，即使乘以补光因子，其亮度值还是过小，无法看到明显的效果。
