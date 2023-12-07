// This typst template is made by absolutex (github.com/lxl66566), works well on typst 0.10.0

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
  代码: ("Fira Code", "Times New Roman", "SimSun"),
)

// 有边线，在右上角显示名字的代码区域
// 如果跨页，则会另起一页
#let frame_with_name(title: none, body) = {
  let stroke = black + 1pt
  let radius = 5pt
  let font = (font: 字体.代码, size: 10pt)
  let name = block(
                breakable: false,
                fill: color.linear-rgb(0, 0, 0, 10),
                stroke: stroke,
                inset: 0.5em,
                below: -1.5em,
                radius: (top-right: radius, bottom-left: radius),
                title,
              )
  set text(..font)
  show raw: set text(..font)
  box(stroke: stroke, radius: radius)[
    #if title != none {
      align(top + right, name)
    }
    #block(
      width: 100%,
      inset: (rest: 0.5em),
      body,
    )
  ]
}

// 引入代码块
#let include_code_file(file_path, name, lang) = {
  frame_with_name(title: name)[
    #raw(read(file_path), lang: lang)
  ]
}

// 只有边框，没有标题提示
#let frame(body) = {
  let stroke = black + 1pt
  let font = (font: 字体.代码)
  set text(..font)
  block(
    stroke: stroke,
    width: 100%,
    inset: (rest: 0.5em),
    radius: 7pt,
    body,
  )
}

#let project(
  title: "", 
  authors: (),
  body
) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center, margin: 0.7in)

  // 正文，两端对齐，段前缩进2字符
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh")
  set par(justify: true,first-line-indent: 2em)
  show heading: it =>  {
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
  }

  // figure(image)
  show figure.where(kind: image): it => [
    #set align(center)
    #if not it.has("kind") {
      it
    } else {
      it.body
      [
        #set text(font: 字体.宋体, size: 字号.五号, weight: "extrabold")
        #h(1em)
        #it.caption
      ]
    }
  ]

  // raw
  show raw.where(block: true): it => frame()[#it]

  body
}
