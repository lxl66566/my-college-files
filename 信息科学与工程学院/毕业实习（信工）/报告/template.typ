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
  宋体: ("Times New Roman", "Songti SC", "Songti TC", "SimSun"),
  黑体: ("Times New Roman", "SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
  代码: ("Fira Code", "Consolas", "monospace", "WenQuanYi Zen Hei Mono", "FangSong"),
)

#let 中文数字(num) = {
  ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(int(num))
}

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

// 提取 text
#let get_text(knt) = {
  knt.at("body", default: knt.at("text", default: "anything"))
}

#let project(
  title: "",
  authors: (),
  body,
) = {
  set document(author: authors, title: title)
  set page(
    numbering: "1",
    paper: "a4",
    number-align: center,
    margin: (top: 2cm, bottom: 2cm, left: 1.5cm, right: 1.5cm),
  )
  // 水印
  // set page(background: rotate(24deg,text(80pt, fill: rgb("FFCBC4"))[*SAMPLE*]))

  // 正文，两端对齐，段前缩进2字符
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh", region: "cn")
  set par(first-line-indent: 2em)
  show heading: it => {
    it
    par()[#text(size: 0.5em)[#h(0.0em)]]
  }

  // heading
  set heading(numbering: "1.1.1.1")
  show heading: it => locate(loc => {
    set text(font: 字体.黑体)
    set par(first-line-indent: 0pt)
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }
    if it.level == 1 {
      set text(字号.四号)
      if it.numbering != none {
        numbering("一、", deepest)
      }
      it.body
    } else if it.level == 2 {
      set text(size: 字号.小四)
      if it.numbering != none {
        numbering("1.1 ", ..levels)
        h(3pt, weak: true)
      }
      it.body
    } else if it.level == 3 {
      set text(size: 字号.五号)
      if it.numbering != none {
        numbering("1.1.1 ", ..levels)
        h(3pt, weak: true)
      }
      it.body
    }
  })


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
  show raw: set text(font: 字体.代码, size: 字号.小五)
  show raw.where(block: true): it => frame()[#it]

  body
}

#let title(title) = {
  // pagebreak(weak: true)
  counter(heading).update(0) // reset header
  align(center)[#text(size: 字号.二号, font: 字体.黑体, title)]
}
