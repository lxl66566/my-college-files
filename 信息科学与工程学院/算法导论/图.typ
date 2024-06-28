#import "../template.typ": *

#show: project.with(
  title: "5",
  authors: (
    "absolutex",
  )
)

= 图

== 完成图的邻接矩阵表示方法，以及图的深度优先搜索与广度优先搜索算法。要求报告给出简单的实验思路（程序的运行方法、简单的分析）、代码与运行结果图

#include_code("算法导论/code/graph.py")

邻接矩阵：
#table(
  columns: 7,
  rows: 7,
[\\],[*0*],[*1*],[*2*],[*3*],[*4*],[*5*],
[*0*],[0],[1],[1],[0],[0],[1],
[*1*],[1],[0],[0],[1],[0],[0],
[*2*],[1],[0],[0],[0],[1],[0],
[*3*],[0],[1],[0],[0],[1],[1],
[*4*],[0],[0],[1],[1],[0],[0],
[*5*],[1],[0],[0],[1],[0],[0],
)

#figure(
  image("static/graph-1.png", width:80%),
  caption: "dfs"
)

#figure(
  image("static/graph-2.png", width:80%),
  caption: "bfs"
)