#import "../template.typ": *

#show: project.with(
  title: "8",
  authors: ("absolutex",),
)

= 机器视觉实践 八

== 实验目的

SIFT 特征检测与匹配
+ 可视化匹配结果

== 实验代码

使用 opencv 库的 SIFT class。具体操作：先从同一张图上切成左右两半（有一定重合区域），然后使用 SIFT 算法进行特征点检测与可视化，最后合并为一张图片。

#include_code("../src/merge/__init__.py")

== 实验结果与心得

#figure(
  image("src.jpg", width: 50%),
  caption: [输入图像],
)

#figure(
  image("points.png", width: 50%),
  caption: [特征点可视化],
)

#figure(
  image("result.jpg", width: 40%),
  caption: [输出图像],
)

经过测试，该算法只能拼接完美截取的图像，不能拼接同一地点、不同角度的相片，因为特征点的 description 不会完全一致，并且对于透视角度的变化也需要更加精确的仿射变换，而非直接拼接。因此，该算法具有一定的局限性。