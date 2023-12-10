#import "../template.typ": *

#show: project.with(
  title: "1",
  authors: (
    "absolutex",
  )
)

= 1 算法复杂度作业
== 按照从增长量级低至高对下列函数进行排序
`f2<f1<f4<f3`
== 按照从增长量级低至高对下列函数进行排序
`f1<f4<f3<f2`
== 按照从增长量级低至高对下列函数进行排序
`f4<f1<f3<f2`
== 课本4.3-1：证明 $T(n) = T(n-1)+n$ 的解为 $O(n^2)$
即证明 $T(n) <= c n^2$。

假定 $m=n-1$，有 $T(n-1) <= c (n-1)^2$，即 

$
T(n)&<=c(n-1)^2+n\

&=c n^2 -(2c-1) n+c\

&=c n^2
$

证毕。
== 课本4.3-2：证明 $T(n) = T(ceil(n/2))+1$ 的解为 $O(lg n)$
即证明 $T(n) <= c lg n$。

假定 $m=ceil(n/2)$，有 $T(ceil(n/2)) <= c lg ceil(n/2)$，即

$
T(n) &<= c lg ceil(n/2) + 1\
&= c lg ceil(n/2)\
&= c lg n
$

证毕。
== $T(n)=2T(n/3)+n lg n$ 是否可用主方法求解复杂度，如果可以请求解

$a=2,b=3,f(n)=n lg n,n^(log_b a)=O(n^0.63)$

当 n 足够大时，取 $c=2/3$，有 $a f(n/b) = 2n/3 lg n/3<=2/3n lg n=c f(n)$，由情况3，解为$T(n)=Theta(n lg n)$

== $T(n)=10T(n/3)+17n^1.2$ 是否可用主方法求解复杂度，如果可以请求解

$a=10,b=3,f(n)=17n^1.2=Theta(n^1.2),n^(log_b a)=O(n^2.09)$

应用第一种方法得 $T(n)=n^(log_3 10)=Theta(n^2.09)$

== $T(n)=sqrt(n)T(sqrt(n))+100n$ 是否可用主方法求解复杂度，如果可以请求解 

T(n) 系数与参数不是常数，不能使用主方法。