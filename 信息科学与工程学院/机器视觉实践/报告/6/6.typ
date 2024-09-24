#import "../template.typ": *

#show: project.with(
  title: "6",
  authors: ("absolutex",),
)

= 机器视觉实践 六

== 实验目的

人脸亮牙

+ 增加牙齿区域的亮度和对比度
+ 要求图像亮牙算法具有实时性
+ 要求在实现图像亮牙的同时，保持其它相邻区域（如嘴唇和牙龈）的颜色和对比度不变

== 实验代码


// #include_code("../src/watermark/LSB.py")

== 实验结果与心得


// #figure(
//   image("DCT1.jpg", width: 100%),
//   caption: [频域直接添加 隐写前后对比],
// )
