#import "../template.typ": *
#import "@preview/tablem:0.1.0": tablem
#import "@preview/mitex:0.2.4": *
#import "@preview/cetz:0.2.2"

#show: project.with(
  title: "9",
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

= 第九章作业

== 9.3 输出功率约束。考虑期望输出功率约束条件P的可加高斯白噪声信道，即，$Y=X+Z，Z~N(0，sigma²)$，Z和X相互独立，并且$E Y^2≤P$。求其信道容量。

由于 $E Y^2≤P$，当$X ~ N(0, P-sigma^2)$时有最大信道容量 = $1/2 log 2 pi e P - 1/2 log 2 pi e sigma^2 = 1/2 log P/sigma^2$

== 9.7 多路高斯信道。考虑一个有功率约束P的可加高斯噪声信道，在该信道中，信号通过两条不同的路径。在天线的一端接收到的信号是由两条路径上传输过来的噪声污染了的信号叠加而成的。

+ 当Z1与Z2为联合正态分布，其协方差矩阵为$K_Z=mat(sigma^2,rho sigma^2;rho sigma^2,sigma^2)$求出该信道的容量。

  $D(Z_1+Z_2)=E(Z_1+Z_2)^2=E[Z_1^2+Z_2^2+2Z_1Z_2]=2sigma^2(1+rho)$

  $C=1 / 2 log (1+4P / N)=1 / 2 log (1+4P / (sigma^2(1+rho)))$

+ 对于$rho=0，rho=1，rho=-1$三种特殊情形，信道容量分别是多少？

  + $C=1 / 2 log (1+4P / (sigma^2 ))$
  + $C=1 / 2 log (1+2P / (sigma^2 ))$
  + $C=infinity$

== 9.8 并联高斯信道。考虑如下的并联高斯信道：$X_1+Z_1=Y_1, X_2+Z_2=Y_2$,其中Z1~N(0,N1)与Z2~N(0,N2)是独立高斯随机变量，而Yi=Xi+Zi。我们希望将功率分配给两个并联信道。选取固定的β1,和β2，考虑全部代价的约束条件$β_1 P_1+β_2 P_2≤β$，其中P;是分配到第i个信道的功率而β:是在该信道中单位功率的代价。于是，P1≥0，P2≥0的选取受到代价β的约束。

+ β取何值时信道停止单信道角色而开始起到双信道的作用？

+ 估计信道容量，求出在β1=1，β2=2，N1=3，N2=2以及β=10时达到信道容量的P1和P2

== 9.15 离散输入，连续输出信道。令 $Pr{X=1}=p,Pr{X=0}=1-p$ 以及Y=X+Z，其中Z是区间$[0，a]，a>1$上的均匀分布，且Z与X相互独立。

+ 计算 $I(X;Y)=H(X)-H(X|Y)$。

  $f(y)=cases((1-p)/a \, & 0<=y<1, 1/a \, & 1<=y<a, p/a \, & a<=y<a+1,0 \, & "其他")$

  $H(X)=-p log p-(1-p) log (1-p)$

  $H(X|Y)$ 仅在 $1 <= y < a$ 时有值，其为积分=$(1-a)/a log 1/a$

+ 通过$I(X;Y)=h(Y)-h(Y|X)$来计算$I(X;Y)$。

  $h(Y)$ 是三段积分，$h(Y|X)$ 是两段积分之和。

+ 通过求关于p的最大值来计算信道容量。

  p=0.5 时有最大 $I(X;Y) = C = 1/a$