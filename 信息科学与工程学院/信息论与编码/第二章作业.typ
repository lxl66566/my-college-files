#import "../template.typ": *
#import "@preview/tablem:0.1.0": tablem
#import "@preview/mitex:0.2.4": *
#import "@preview/cetz:0.2.2"

#show: project.with(
  title: "2",
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

= 第二章作业

== 2.12

a. $H(X)=-2/3 log 2/3 - 1/3 log 1/3 = 0.918 "bits" = H(Y)$

b. #mi[`H(X|Y)=\frac{1}{3}H(X|Y=0)+\frac{2}{3}H(X|Y=1)=0.667\text{ bits }=H(Y|X)`]

c. #mi[`H(X,Y)=3\times\frac{1}{3}\log3=1.585 \mathrm{bits}`]

d. #mi[`H(Y)-H(Y|X)=0.251 \mathrm{bits}`]

e. #mi[`I(X;Y)=H(Y)-H(Y|X)=0.251&\text{ bits.}`]

f. #cetz.canvas({
  import cetz.draw: *
  circle((3, 0),radius: (3,3), stroke: blue)
  circle((6.5, 0),radius: (3,3), stroke: blue)
  content((2,0), [$H(X|Y)$])
  content((5,0), [$I(X;Y)$])
  content((8,0), [$H(Y|X)$])
  content((5,3.2), [$H(X,Y)$])
  content((2,-3), [$H(X)$])
  content((7.5,-3), [$H(Y)$])
})

== 2.18

世界职业棒球锦标赛。世界职业棒球锦标赛为7场系列赛制，只要其中一队赢得4场，比赛就结束。设随机变量X代表在棒球锦标赛中，A队和B队较量的结果。例如，X的取值可能为AAAA，BABABAB，BBBAAAA。设Y代表比赛的场数，取值范围为4～7。假定A队和B队是同等水平的，且每场比赛相互独立。试计算$H(X)$,$H(Y)$,$H(Y|X)$及$H(X|Y)$.

#tablem[
  | 场数 | 4 | 5 | 6 | 7 |
  | ------ | ----- | ---- | --- | --- |
  | 概率 | $2/2^4 = 1/8$ | $8/2^5 = 1/4$ | $20/2^6 = 5/16$ | $40/2^7 = 5/16$ |
]

#mi[`
H(X)= \sum p(x)log\frac{1}{p(x)} \\
=2(1/16)\log16+8(1/32)\log32+20(1/64)\log64+40(1/128)\log128 \\
= 5.8125
`]

#mi[`
H(Y)=\sum p(y)log\frac{1}{p(y)} \\
= 1/8\log8+1/4\log4+5/16\log(16/5)+5/16\log(16/5)\\
=1.924`]

$H(Y | X)=0$

#mi[`H(X|Y)=H(X)+H(Y|X)-H(Y)=3.889`]

== 2.32

a. 试求最小误差概率估计量$hat(X) (Y)$与相应的 $P_e$

$hat(X)(y) = cases(1\, & y=a,2\, & y=b, 3\, & y=c)$

$P_e = P(1,b)+ P(1,c)+ P(2,a)+ P(2,c)+ P(3,a)+ P(3,b)=1 / 2$

b. 估计出该习题的费诺不等式，并与(a)中求得的值比较。

$P_e>=((H(X|Y)-1) / (log |chi|))$

$H(X|Y)=H(1 / 2,1 / 4,1 / 4)=1.5 "bits"$

$P_e>= ((1.5-1) / (log 3))=0.316$

== 2.35

相对熵是不对称的。设随机变量X有三个可能的结果{a，b，c}。考虑该随机变量上的两个分布（右表）：计算$H(p)$,$H(q)$,$D(p||q)$和 $D(q||p)$,并验证在此情况下 $D(p||q)≠D(q||p)$。

#mi[`\begin{gathered}
H(p)=\frac{1}{2}\operatorname{log}2+\frac{1}{4}\operatorname{log}4+\frac{1}{4}\operatorname{log}4=1.5\mathrm{~bits.} \\
H(q)=\frac{1}{3}\operatorname{log}3+\frac{1}{3}\operatorname{log}3+\frac{1}{3}\operatorname{log}3=\operatorname{log}3=1.585\mathrm{~bits.} \\
D(p||q)=\frac{1}{2}\operatorname{log}\frac{3}{2}+\frac{1}{4}\operatorname{log}\frac{3}{4}+\frac{1}{4}\operatorname{log}\frac{3}{4}=\operatorname{log}(3)-1.5=1.585-1.5=0.085 \\
D(q||p)=\frac13\operatorname{log}\frac23+\frac13\operatorname{log}\frac43+\frac13\operatorname{log}\frac43=\frac53-\operatorname{log}(3)=1.667-1.585=0.082
\end{gathered}`]