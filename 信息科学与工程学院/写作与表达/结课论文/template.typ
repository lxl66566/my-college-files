#import "functions/numbering.typ": *

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
  set heading(level: 1, numbering: none)
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
  set heading(level: 1, numbering: none)
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

// 引用
#let references(path) = {
  set heading(level: 1, numbering: none)
  bibliography(path, title:"参考文献", style: "gb-7114-2015-numeric")
}


#let project(
  title: "", 
  authors: (),  
  abstract_zh: [],
  abstract_en: [],
  keywords_zh: (),
  keywords_en: (), 
  body
) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center)

  // 两端对齐，段前缩进2字符
  set par(justify: true,first-line-indent: 2em)
  show heading: it =>  {
    it
    par()[#text(size:0.5em)[#h(0.0em)]]
  }


  // 正文
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh")

  // heading
  show heading: set text(font: 字体.黑体)
  set heading(numbering: "1.1")
  // 一级标题换页，首行居中
  show heading: it => {
    if it.level == 1 {
      pagebreak(weak: true)
      align(center)[#text(font: 字体.黑体, size: 字号.小二, it)]
    }
    else if it.level == 2 {
      text(font: 字体.黑体, size: 字号.四号, it)
    }
    else if it.level == 3 {
      text(font: 字体.黑体, size: 字号.小四, it)
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

  // Title
  align(center)[
    #block(text(font: 字体.黑体, size: 字号.二号, weight: "bold", title))
  ]

  // 摘要
  zh_abstract_page(abstract_zh, keywords: keywords_zh)
  pagebreak()
  en_abstract_page(abstract_en, keywords: keywords_en)
  pagebreak()

  body

  // 参考文献
  references("./ref.bib")
}
