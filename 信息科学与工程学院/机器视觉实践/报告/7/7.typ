#import "../template.typ": *

#show: project.with(
  title: "7",
  authors: ("absolutex",),
)

= 机器视觉实践 七

== 实验目的

结肠镜图像局部分割

+ 编程实现结肠镜图像局部分割
+ 要求用曲线分割出息肉的区域

== 实验代码

一般的图像处理应该很难做到这一点，所以直接使用大模型。

模型是 kaggle 上的 Automatic Polyp Detection in Colonoscopic Frames，使用 U-Net: Convolutional Networks for Biomedical Image Segmentation 训练，数据集为 CVC-ClinicDB。最终模型大小 130MB。

此处代码是加载模型并进行预测的代码。

#include_code("../src/polyp/__init__.py")

== 实验结果与心得

#figure(
  image("res.png", width: 100%),
  caption: [效果图],
)

所有息肉均分辨无误。