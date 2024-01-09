// typst 0.10.0
#import "../template.typ": *
#import "@preview/mitex:0.1.0": *
#import "@preview/tablem:0.1.0": tablem

#let 手写字体=(
  "德彪钢笔行书字库", "LiDeBiao-Xing3", // 德彪钢笔行书 https://freefonts.top/font/60a68009f694d7302081e78b
  "田英章楷书", // https://eng.m.fontke.com/font/13069604/download/
  "ChenDaiMing", // 陈代明硬笔体 https://freefonts.top/font/60bef156aa520e302b8e8922
  "FZQiTi-S14S", // 方正启功简体
)

#let project(
  title: "电子认识实习", 
  authors: ("absolutex"),
  body
) = {
  set document(author: authors, title: title)

  set text(font: 字体.宋体, size: 字号.小四, lang: "zh", region: "cn")

  set page(
    numbering: (..nums) => {
      "第" + str(nums.pos().at(0)) + "页，共" + str(nums.pos().at(-1)) + "页"
    },
    number-align: center, 
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 1.5cm),
    header: [
      #set align(center)
      #set text(font: 字体.宋体, size: 字号.小五)
      《电子认识实习》报告
    ]
  )

  set par(first-line-indent: 2em)
  show heading: it => {
    it
    fake_par
  }

  // heading，一级标题换页且不显示数字，首行居中
  set heading(numbering: (..nums) => 
    if nums.pos().len() == 1 {
      中文数字(nums.pos().first()) + "、"
    } 
    else {
      nums.pos().slice(1,..).map(str).join(".") + "."
    }
  )
  show heading: it => {
    if it.level == 1 {
      text(size: 字号.小三, font: 字体.黑体, it)
    }
    else if it.level == 2 {
      text(size: 字号.小四,  font: 字体.黑体, it)
    }
    else if it.level == 3 {
      text(size: 字号.小四, it)
    }
    else{
      text(size: 字号.五号, it)
    }
  }

  // figure(image)
  show figure.where(kind: image): it => {
    set align(center)
    it.body
    {
      set text(font: 字体.宋体, size: 字号.五号, weight: "extrabold")
      h(1em)
      it.caption
    }
  }

  // raw with frame
  show raw: set text(font: 字体.代码)
  show raw.where(block: true): it => frame()[#it]

  set enum(numbering: "1.")

  show outline: ol => {
    show heading: it => {
      align(center)[#text(size: 字号.小三, font: 字体.黑体, it)]
    }
    set par(first-line-indent: 0pt)
    ol
  }
  show outline.entry: it => {
    set text(font: 字体.宋体, size: 字号.小四)
    it
  }
  set outline(indent: auto)

  outline()
  pagebreak()

  align(center)[#text(size: 字号.三号, font: 字体.黑体, "数字式交流电压表设计")]

  body
}

#let answer(body) = {
  text(font: 手写字体, body)
}

#show: project.with(
  title: "电子认识实习",
  authors: (
    "absolutex",
  )
)


= 设计要求

+ 输入交流电压范围：0～200mV（有效值）
+ 要求用三位 LED 数显测得的电压值，分辨率为 1 mV
+ 可用的主要元器件：高阻抗双运放 LF353N、通用运放 LM741、MC14433
+ 实验器材：示波器、万用表、函数信号发生器、交流毫伏表、直流电源
+ 电源电压：±5V

= 设计过程

== 系统功能

本实验要求设计一个数字式交流电压表，其功能是：测量输入交流电压，并在数字显示管上显示测量结果。

== 设计流程

#figure(
  image("static/1.png", width: 80%),
  caption: [设计流程],
)

== 整流滤波、放大电路

#figure(
  image("static/2.png", width: 80%),
  caption: [整流滤波、放大电路原理图],
)

由于输入量是交流信号，因此首先必需将交流信号变为直流信号，图 2 电路可以实现上述要求。

设：R1＝R3＝R4＝R7＝R8＝10K，R2＝R5＝5.1K，R6＝20K，R9＝100K。
当 $V_i>0$ 时，$D_2$ 导通，$D_1$反向偏置，$A 1$ 为同向放大器。

此时，$V_(o 1)=(R_1+R_3)/(R_1)V_i=2V_i$，A2 则将反向输入端的 $V_(o 1)$ 及同向输入端的 $V_i$信号同时放大，#mi[`V_{o2}=-\frac{R_6}{R_4}V_{o1}+\frac{R_4+R_6}{R_4}V_i=-V_i`]。

当 $V_i <0$ 时，$D_1$导通，$D_2$反向偏置，A1 为增益等于 1 的跟随器，$V_(o 1)=V_i$。

A2则将反向输入端的$V_(o 1)$及同向输入端的$V_i$信号同时放大，#mi[`\mathrm{V}_{\mathrm{o}2}=-\frac{\mathrm{R}_6}{\mathrm{R}_4+\mathrm{R}_3}\mathrm{V}_{\mathrm{o}1}+\frac{\mathrm{R}_3+\mathrm{R}_4+\mathrm{R}_6}{\mathrm{R}_3+\mathrm{R}_4}\mathrm{V}_i=\mathrm{V}_i`]，因此，$V_(o 2) = −V_i$ ，$V_(o 2)$的线性度不受二极管非线性的影响。

A3 作反相放大，将输入信号放大至 0～2V 标准信号。$R_9$、$W_1$、$C_2$ 组成滤波。

== A/D 转换、译码驱动、数字显示

#figure(
  image("static/3.png", width: 80%),
  caption: [由 MC14433 集成电路组成的 3 位半数字电压表原理图],
)

A/D 转换、译码驱动、数字显示采用 MC14433 组成的 3 位半数字电压表电路，如图 3 所示。

用数字方法处理模拟信号时，必须先将模拟量转换成数字量，这是由模拟—数字转换器（A/D）完成的。

A/D 转换的方法很多，本实验用到的 MC14433是双积分式 A/D 转换器。双积分式 A/D 转换器的特点是线路结构简单，外接元件少，抗共模干扰能力强，但转换速度较慢（3～10次/秒），使用时只要外接两个电阻和两个电容就能执行$3 1/2$位的 A/D 转换。由于它的二—十进制转换码采用数据轮流扫描输出方式，因而只需一块七段译码显示 $3 1/2$位十进制数，大大节省了外部电路的数量和显示电路的功耗，这对 LED 显示的数字表特别有利。

== 设计结果

本次实验分为两个模块，一个是模拟信号处理电路，另一个是A/D转换与数字显示电路。图 4 是模拟信号处理电路的原件排列图：

#figure(
  image("static/circuit.png", width: 90%),
  caption: [元件排列图],
)

其中，电阻 R1,R3,R4,R7,R8 为 $10K Omega$，电阻 R6 为 $20K Omega$，W1 为 $33K Omega$ 可调电位器，W2 为 $10K Omega$ 可调电位器。

此设计图使用了尽可能少的飞线（共计 4 根），具有较好的物理稳定性。但是这也导致了其余焊点连接较多，锡的使用量较大，并且提高了焊点连接的难度。

= 数据处理

#tablem[
  |输入信号有效值(mV)|显示电压有效值(mV)|误差(mV)|输入信号有效值(mV)|显示电压有效值(mV)|误差(mV)|
  |---|---|---|---|---|---|
  |0|4.7|4.7|110| 108.5|1.5|
  |10| 12.9|2.9|120| 118.4|1.6|
  |20| 23.0|3.0|130| 127.9|2.1|
  |30| 31.6|1.6|140| 137.7|2.3|
  |40| 41.2|1.2|150| 147.1|2.9|
  |50| 52.5|2.5|160| 157.5|2.5|
  |60| 61.9|1.9|170| 170.6|0.6|
  |70| 71.7|1.7|180| 180.0|0.0|
  |80| 81.2|1.2|190| 190.4|0.4|
  |90| 90.5|0.5|200| 199.9|0.1|
  |100| 98.9|1.1| | | |
]

输入信号为 0 时，

#figure(
  image("static/data1.png", width: 60%),
  caption: [输入信号与输出信号的关系],
)

可以看出输入信号与输出信号大致呈线性关系，并且数值基本相同。

#figure(
  image("static/data2.png", width: 60%),
  caption: [输入信号与误差的关系],
)

= 调试过程