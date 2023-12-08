#import "template.typ": *
#import "@preview/tablem:0.1.0": tablem


#show: project.with(
  title: "理论 5",
  authors: (
    "absolutex",
  )
)

= P3
考虑下面的网络。对于标明的链路开销，用Dijkstra的最短路算法计算出从x到所有网络节点的最短路径。通过计算一个类似于表5-1的表，说明该算法是如何工作的。

#tablem[
  |步骤|N'|D(u),p(u)|D(v),p(v)|D(w),p(w)|D(y),p(y)|D(z),p(z)|D(t),p(t)|
  |---|---|---|---|---|---|---|---|
  |1  |x  |$infinity$  |3,x  |6,x  |6,x  |8,x  |$infinity$ |
  |2|xv|6,v|3,x|6,x|6,x|8,x|7,v|
  |3|xvu|6,v|3,x|6,x|6,x|8,x|7,v|
  |4|xvuw|6,v|3,x|6,x|6,x|8,x|7,v|
  |5|xvuwy|6,v|3,x|6,x|6,x|8,x|7,v|
  |6|xvuwyt|6,v|3,x|6,x|6,x|8,x|7,v|
  |7|xvuwytz|6,v|3,x|6,x|6,x|8,x|7,v|
]

= P5
考虑下图所示的网络，假设每个节点初始时知道到它的每个邻居的开销。考虑距离向量算法，请给出节点z处的距离表表项。

#tablem[
  |节点|u|v|x|y|z|
  |---|---|---|---|---|---|
  | u | 0 | 1 | 4 | 2 | 6 |
  | v | 1 | 0 | 3 | 3 | 5 |
  | x | 4 | 3 | 0 | 3 | 2 |
  | y | 2 | 3 | 3 | 0 | 5 |
  | z | 6 | 5 | 2 | 5 | 0 |
]