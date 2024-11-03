#import "../template.typ": *
#import "@preview/tablem:0.1.0": tablem
#import "@preview/mitex:0.2.4": *
#import "@preview/cetz:0.2.2"

#show: project.with(
  title: "8",
  authors: ("absolutex",),
)

#set par(first-line-indent: 0em) // 不换行
#show heading: it => {
  set text(font: 字体.黑体)
  if it.level == 1 {
    pagebreak(weak: true)
    align(center)[#text(size: 字号.小二, it.body)]
  } else if it.level == 2 {
    // 不标序号
    text(size: 字号.四号, it.body)
  } else if it.level == 3 {
    text(size: 字号.小四, it)
  } else {
    text(size: 字号.五号, it)
  }
}

= 第八章作业

== 8.1 微分熵。计算下列各密度函数的微分熵 $h（X）=-integral f ln f$：

+ 指数密度函数$f(x)=lambda e^(-lambda x),x≥0$。

  $h(X)&=-integral lambda e^(-lambda x) (
      ln lambda - lambda x
    ) d x \ &= ln lambda e^(-lambda x)|_0^(+infinity)-lambda e^(-lambda x)|_0^(+infinity)\ &=1-ln lambda "nats" \ &= log e / lambda "bits"$

+ 拉普拉斯密度函数 $f(x)=1/2 lambda e^(-lambda |x|)$

  $h(x)&=-1 / 2 lambda (
      integral_0^(+infinity) e^(-lambda x) d x + integral_(-infinity)^0 e^(lambda x) d x
    )\ &= -ln 1 / 2-ln lambda + 1\ &=log (2e) / lambda "bits"$

+ X1与X2的和的密度函数，其中X1与X2是独立的正态分布，均值为$μ_i$，方差为 $sigma_i^2$

  $h(f)=1 / 2 log(2π e(sigma_1^2+sigma_2^2))$

== 8.3 均匀分布噪声。设一个信道的输入随机变量X服从区间$-1/2≤x≤1/2$上的均匀分布，而信道的输出信号为$Y=X+Z$，其中Z是噪声随机变量，服从区间$-a/2≤z≤a/2$上的均匀分布。

+ 求$I(X;Y)$作为a的函数。

  $I(X;Y) = h(Y) -h(Y|X) =h(Y) -h(Z)$

  Y 的取值范围为 $[-(1+a)/2,(1+a)/2]$ 的关于Y轴对称的三角形区域，且面积为 1。三角形高为$1/(1+a)$。

  $h(Y) = integral_(-(1+a) / 2)^0 2 / (1+a)^2 x log (1+a)^2 x d x+integral_0^(1 / 2) -2 / (1+a)^2 x log -2 / (
      1+a
    )^2 x d x$

+ 对于$a=1$，当输入信号X是峰值约束的时候，即X的取值范围限制于$-1/2≤x≤1/2$时，求信道容量。为使得互信息$I（X;Y）$达到最大值，X应该服从什么概率分布？

  Y 为均匀分布时，互信息最大。因此当 X 服从 $-1/2, 1/2$ 两点分布时，此时 Y 在 $[-1, 1]$ 上均匀分布，有最大 $I(X;Y)=1$

+ （选做）当a的取值没有限制时，求信道容量。这里仍然假定X的范围限制于$-1/2≤x<1/2$。

== 8.8 有均匀干扰噪声的信道。设一个可加信道的输入字母表$chi={0，±1，±2}$而输出为Y=X+Z，其中，Z是区间 [-1,1]上的均匀分布。于是，信道的输入是一个离散的随机变量，否则输出是连续型的。计算该信道的容量$C=max_p(x) I(X;Y)$。

$h(Z) =1$

$I(X;Y)= h(Y) -h(Y|X) =h(Y) -h(Z)$

$-3<=Y<=3$，为了满足唯一性，X 应该取 0 和 ±2，此时可以从 Y 唯一推出 X，Y 的分布为 $[-3, 3]$ 上的均匀分布。所以 $I(X;Y) = log 6$