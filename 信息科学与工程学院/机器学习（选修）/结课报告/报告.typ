#let 字号 = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  中四: 13pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  小七: 5pt,
)

#let 字体 = (
  仿宋: ("Times New Roman", "FangSong"),
  宋体: ("Times New Roman", "SimSun"),
  黑体: ("Times New Roman", "SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
  代码: ("New Computer Modern Mono", "Times New Roman", "SimSun"),
)

// 中文摘要
#let zh_abstract_page(abstract, keywords: ()) = {
  set heading(level: 1, numbering: none, outlined: false)
  show <_zh_abstract_>: {
    align(center)[
      #text(font: 字体.黑体, size: 字号.小二, "摘要")
    ]
  }
  [= 摘要 <_zh_abstract_>]

  set text(font: 字体.宋体, size: 字号.小四)

  abstract
  par(first-line-indent: 0em)[
    #text(weight: "bold", font: 字体.黑体, size: 字号.小四)[
      关键词：
    ]
    #keywords.join("；")
  ]
}

// 英文摘要
#let en_abstract_page(abstract, keywords: ()) = {
  set heading(level: 1, numbering: none, outlined: false)
  show <_en_abstract_>: {
    align(center)[
      #text(font: 字体.黑体, size: 字号.小二, "Abstract")
    ]
  }
  [= Abstract <_en_abstract_>]

  set text(font: 字体.宋体, size: 字号.小四)

  abstract
  par(first-line-indent: 0em)[
    #text(weight: "bold", font: 字体.黑体, size: 字号.小四)[
      Key Words:
    ]
    #keywords.join("; ")
  ]
}

#let project(
  title: "",
  authors: (),
  abstract_zh: [],
  abstract_en: [],
  keywords_zh: (),
  keywords_en: (),
  body,
) = {
  set document(author: authors, title: title)
  set page(
    numbering: "I",
    number-align: center,
    header: [#text(size: 字号.五号, title)#line(length: 100%)],
  )

  // 两端对齐，段前缩进2字符
  set par(justify: true, first-line-indent: 2em)
  show heading: it => {
    it
    par()[#text(size: 0.5em)[#h(0.0em)]]
  }


  // 正文
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh")

  // heading
  show heading: set text(font: 字体.黑体)
  set heading(numbering: "1.1")

  show heading: it => {
    if it.level == 1 {
      text(font: 字体.黑体, size: 字号.四号, it)
    } else if it.level == 2 {
      text(font: 字体.黑体, size: 字号.小四, it)
    } else if it.level == 3 {
      text(font: 字体.黑体, size: 字号.五号, it)
    }
  }

  // figure(image)
  show figure: it => [
    #set align(center)
    #if not it.has("kind") {
      it
    } else if it.kind == image {
      it.body
      [
        #set text(font: 字体.宋体, size: 字号.五号, weight: "extrabold")
        #h(1em)
        #it.caption
      ]
    } else if it.kind == table or it.kind == code {
      [
        #set text(font: 字体.宋体, size: 字号.五号, weight: "bold")
        #h(1em)
        #it.caption
      ]
      it.body
    }
  ]

  show outline: ol => {
    set par(first-line-indent: 0pt)
    ol
  }

  set page(numbering: "1")

  align(center)[#text(font: 字体.黑体, size: 字号.小二, title)]
  body
}

#show: project.with(
  title: "使用预训练模型进行推理",
  authors: ("absolutex",),
)

= 前言

本报告是一份使用心得，以此作为机器学习的结课报告。

在机器学习的课程中，我学会了如何使用回归模型、神经网络等算法进行模型训练的原理，并且在作业中调用 python 库 `sklearn.neural_network` 进行训练。但是，更进一步的模型训练需要学习如何调整参数，学习更多的机器学习算法，并付出大量训练时间和GPU资源。如果我不想自己训练模型，而是使用预训练模型，我需要怎么做呢？

== llama.cpp

llama.cpp是一个基于C++编写的高性能计算库，旨在提供快速、稳定且易于使用的计算工具。它采用了先进的并行计算技术，充分利用多核处理器和分布式系统的优势，实现了高效的计算性能。llama.cpp支持多种计算模式，包括向量计算、矩阵运算、图算法等，可广泛应用于机器学习、图像处理、数据分析等领域。

`llama.cpp` 的主要特点包括：
- 高性能计算：它是一个基于 C++ 编写的高性能计算库，旨在提供快速、稳定且易于使用的计算工具。
- 并行计算技术：采用了先进的并行计算技术，充分利用多核处理器和分布式系统的优势，实现了高效的计算性能³。
- 优化底层计算和内存管理：通过优化底层计算和内存管理，可以在不牺牲模型性能的前提下提高推理速度。

=== 下载

网上所说的方法大多是用 git clone 进行源码包拉取。由于 ssh 速度较慢，且这样会拉取到所有历史提交记录与所有分支，会引入不必要的复杂性。我并不需要在本地不断与上游更新同步，因此我直接从 github 下载了 ZIP 包。

在 windows 上，配置好 C++ 环境后编译仍会报错。因此我尝试切换到 linux 下进行编译。