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

llama.cpp (https://github.com/ggerganov/llama.cpp) 是一个基于C++编写的高性能计算库，旨在提供快速、稳定且易于使用的计算工具。它采用了先进的并行计算技术，充分利用多核处理器和分布式系统的优势，实现了高效的计算性能。llama.cpp支持多种计算模式，包括向量计算、矩阵运算、图算法等，可广泛应用于机器学习、图像处理、数据分析等领域。

`llama.cpp` 的主要特点包括：
- 高性能计算：它是一个基于 C++ 编写的高性能计算库，旨在提供快速、稳定且易于使用的计算工具。
- 并行计算技术：采用了先进的并行计算技术，充分利用多核处理器和分布式系统的优势，实现了高效的计算性能³。
- 优化底层计算和内存管理：通过优化底层计算和内存管理，可以在不牺牲模型性能的前提下提高推理速度。

=== 安装

在 windows 上，配置好 C++ 环境后尝试编译，仍会报错，指向看不懂的 C++ 错误。因此我尝试切换到 linux 下进行编译。

首先，下载源码包：

```sh
git clone git@github.com:ggerganov/llama.cpp.git -b master --depth 1
```

只克隆 master 分支和设置深度为 1 可以减少一些下载量。然后执行

```sh
make -j8
```

进行编译，此处使用 8 线程。linux 下可以一遍编译成功，文件夹下会多出 `main` 可执行文件。

当然，也可以直接去 Release 中下载编译好的可执行文件，又快又能避开环境问题，预编译文件和预训练模型也非常相配。

=== 下载模型

此处我选择从huggingface下载已经过量化的成品模型。这里我选用的是 llama2-uncensored (https://huggingface.co/georgesung/llama2_7b_chat_uncensored)，一个经过微调的 Llama-2 7B。

顺带一提，在 huggingface 下载模型的官方教程使用的也是 git 下载，但是速度比较慢。这个回答 (https://stackoverflow.com/questions/67595500/) 给出了许多工具，可以帮助我方便快速地下载模型。

=== 交互式运行

准备就绪，现在我可以运行下面的代码，使用 llama.cpp 加载模型，并交互式输入。

```sh
./main -m llama2-uncensored --color -ins -c 2048 --temp 0.2 -n 256 --repeat_penalty 1.1
```

这里是一些参数的说明：

- `-m` 指定模型
- `-c` 控制上下文的长度，值越大越能参考更长的对话历史（默认：512）
- `-ins` 启动类ChatGPT对话交流的instruction运行模式
- `-f` 指定prompt模板
- `-n` 控制回复生成的最大长度（默认：128）
- `-b` 控制batch size（默认：8），可适当增加
- `-t` 控制线程数量（默认：4），可适当增加
- `--repeat_penalty` 控制生成回复中对重复文本的惩罚力度
- `--temp` 温度系数，值越低回复的随机性越小，反之越大
- `--top_p`, top_k 控制解码采样的相关参数

这里是运行的结果：

#figure(image("static/ex.png"))

可以看出，这个只有 7B 参数，3.8GB 大小的模型并不强大，第二句话就开始胡说八道。但是至少它在我的机器上成功运行了，并且能够给出语句通顺的回答。

== ollama

当然，在大语言模型如井喷般迅猛发展的现在，llama.cpp 并不能算是一个足够好用的工具。这里我又尝试了 ollama (https://github.com/ollama/ollama)，一个用 go 语言写的，无脑上手的大模型运行工具，本质上是对 llama.cpp 的包装。

=== 安装

go 语言具有统一的包管理，我原以为只需要执行

```sh
git clone git@github.com:ollama/ollama.git -b main --depth 1
cd ollama
go generate ./...
go build main.go
```

即可拉取源代码，并构建可执行文件。（参考了官方的开发者指南 https://github.com/ollama/ollama/blob/main/docs/development.md）

但是实际上这个安装也会拉取 llama.cpp 仓库并尝试编译，并且编译时也会报错：`Compiling the CUDA compiler identification source file "CMakeCUDACompilerId.cu" failed.`，也是无法简单解决的问题。

因此我也不推荐从源代码编译，可以直接下载已编译好的可执行文件。

=== 使用

ollama 最大的特点就是易用。只需要执行一句

```sh
ollama run llama3
```

其就会自动下载 llama3 模型，并使用默认的参数运行。代价就是无法像使用 llama.cpp 那样作出精细的参数控制。