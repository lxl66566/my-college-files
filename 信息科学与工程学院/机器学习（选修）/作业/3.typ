// This typst template is made by absolutex (github.com/lxl66566), works well on typst 0.11.0

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
  宋体: ("Times New Roman", "Songti SC", "Songti TC", "SimSun"),
  黑体: ("Times New Roman", "SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
  代码: ("Fira Code", "Consolas", "monospace", "WenQuanYi Zen Hei Mono", "FangSong"),
)

// 带边框代码块
#let frame(title: none, body) = {
  let stroke = black + 1pt
  let radius = 5pt
  let txt = (font: 字体.代码)
  set text(..txt)
  let name = block(
                breakable: false,
                fill: color.linear-rgb(0, 0, 0, 10),
                stroke: stroke,
                inset: 0.5em,
                below: -1.5em,
                radius: (top-right: radius, bottom-left: radius),
                title,
              )
  block(
    stroke: stroke,
    width: 100%,
    inset: (rest: 0.5em),
    radius: radius,
  )[
    #if title != none {
      place(top + right, dx: radius + stroke.thickness, dy: -(radius + stroke.thickness), name)
    }
    #body
  ]
}

// 引入外部代码块
#let include_code(file_path) = {
  let name = file_path.split("/").at(-1)
  let lang = name.split(".").at(-1)
  frame(title: name)[
    #raw(read(file_path), lang: lang)
  ]
}

// 设置假缩进
#let fake_par = {
  v(-0.5em)
  box()
}

#let project(
  title: "", 
  authors: (),
  body
) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center, margin: 0.7in)
  // 水印
  // set page(background: rotate(24deg,text(80pt, fill: rgb("FFCBC4"))[*SAMPLE*]))

  // 正文，两端对齐，段前缩进2字符
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh", region: "cn")
  set par(first-line-indent: 2em)
  show heading: it => {
    it
    par()[#text(size:0.5em)[#h(0.0em)]]
  }

  // heading，一级标题换页且不显示数字，首行居中
  set heading(numbering: "1.1")
  show heading: it => {
    set text(font: 字体.黑体)
    if it.level == 1 {
      pagebreak(weak: true)
      align(center)[#text(size: 字号.小二, it.body)]
    }
    else if it.level == 2 {
      text(size: 字号.四号, it)
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

  body
}

#show: project.with(
  title: "project 3",
  authors: (
    "absolutex",
  )
)

= Project3-Mnist：基于BP神经网络的手写数字识别

== 要求

针对资料中的 Mnist 手写数字识别数据集 `MNIST.train.csv`，进行训练和验证。Python：建立基于神经网络的识别模型。若用 SKLearn 库函数 MPLClassifier 使用说明见课件。试尝试 2 种以上模型参数并进行分析比较，如单隐层、3 隐层等、隐藏层数目、不同优化函数等不同网络参数的影响。并可以进行前若干个手写数据的图像的可视化，可以利用 `image=x.reshape(-1,28,28)` 进行维度转换。

== 代码

单隐层和三隐层的区别之处只修改了一行代码。

#include_code("3.py")

== 结果

=== 单隐层

```
Accuracy: 0.96
              precision    recall  f1-score   support

           0       0.98      0.98      0.98       810
           1       0.98      0.99      0.98      1004
           2       0.96      0.96      0.96       821
           3       0.95      0.95      0.95       841
           4       0.98      0.94      0.96       854
           5       0.95      0.96      0.95       781
           6       0.97      0.98      0.97       816
           7       0.97      0.97      0.97       858
           8       0.94      0.95      0.94       771
           9       0.94      0.94      0.94       844

    accuracy                           0.96      8400
   macro avg       0.96      0.96      0.96      8400
weighted avg       0.96      0.96      0.96      8400
```

=== 三隐层

```
Accuracy: 0.97
              precision    recall  f1-score   support

           0       0.97      0.98      0.98       810
           1       0.99      0.99      0.99      1004
           2       0.96      0.97      0.96       821
           3       0.97      0.94      0.96       841
           4       0.96      0.97      0.97       854
           5       0.97      0.94      0.96       781
           6       0.98      0.99      0.98       816
           7       0.98      0.96      0.97       858
           8       0.93      0.97      0.95       771
           9       0.95      0.96      0.95       844

    accuracy                           0.97      8400
   macro avg       0.97      0.97      0.97      8400
weighted avg       0.97      0.97      0.97      8400
```

=== 图像输出

单隐层和三隐层的前 5 张图片识别结果完全一致。

#figure(
  image("static/3.1.png", width: 60%),
  caption: [ex1]
)
#figure(
  image("static/3.2.png", width: 60%),
  caption: [ex2]
)
#figure(
  image("static/3.3.png", width: 60%),
  caption: [ex3]
)
#figure(
  image("static/3.4.png", width: 60%),
  caption: [ex4]
)
#figure(
  image("static/3.5.png", width: 60%),
  caption: [ex5]
)