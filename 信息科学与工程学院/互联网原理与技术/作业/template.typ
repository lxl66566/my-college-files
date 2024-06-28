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

#let answer(body) = {
  set par(justify: true,first-line-indent: 2em)
  body
}

#let project(
  title: "", 
  authors: (),
  body
) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center, margin: 0.7in)

  set text(font: 字体.宋体, size: 字号.小四, lang: "zh") 

  // heading，一级标题换页，首行居中
  show heading: set text(font: 字体.黑体)
  set heading(numbering: "1.1")
  show heading: it => {
    if it.level == 1 {
      text(font: 字体.黑体, size: 字号.四号, it)
    }
    else if it.level == 2 {
      text(font: 字体.黑体, size: 字号.小四, it)
    }
    else if it.level == 3 {
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
    } else if it.kind == code {
      [
        #set text(font: 字体.宋体, size: 字号.五号, weight: "bold")
        #h(1em)
        #it.caption
      ]
      it.body
    }
  ]

  align(center)[
    #block(text(font: 字体.黑体, size: 字号.二号, weight: "bold", title))
  ]

  body
}
