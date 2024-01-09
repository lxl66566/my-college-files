// typst 0.10.0
#import "../template.typ": *
#import "@preview/gviz:0.1.0": *

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
      nums.pos().slice(1,..).map(str).join(".")
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
  show raw.where(lang: "dot-render"): it => render-image(it.text)

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

首先写出设计流程框图：

#figure(
  image("static/1.png", width: 80%),
  caption: [设计流程],
)

== 整流滤波、放大电路

由于输入量是交流信号，因此首先必需将交流信号变为直流信号，图 2 电路可以实现上述要求。

设：R1＝R3＝R4＝R7＝R8＝10K，R2＝R5＝5.1K，R6＝20K，R9＝100K。
当 $V_i>0$ 时，$D 2$ 导通，$D 1$反向偏置，$A 1$ 为同向放大器。

此时，$V_(o 1)=(R_1+R_3)/(R_1)V_i=2V_i$，A2 则将反向输入端的 $V_(o 1)$ 及同向输入端的 $V_i$信号同时放大，当 $V_i <0$ 时，D1导通，D2反向偏置，A1 为增益等于 1 的跟随器，Vo1＝Vi。
A2则将反向输入端的Vo1及同向输入端的Vi信号同时放大，
因此，Vo2 = − Vi ，Vo2的线性度不受二极管非线性的影响。
