#import "../template.typ": *
#import "@preview/mitex:0.1.0": *

#let 手写字体=(
  "田英章楷书", // https://eng.m.fontke.com/font/13069604/download/
  "LiDeBiao-Xing3", // 德彪钢笔行书 https://freefonts.top/font/60a68009f694d7302081e78b
  "ChenDaiMing", // 陈代明硬笔体 https://freefonts.top/font/60bef156aa520e302b8e8922
  "FZQiTi-S14S", // 方正启功简体
)

#let project(
  title: "数字信号处理", 
  authors: ("absolutex"),
  body
) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center, margin: 0.7in)

  // 正文，两端对齐，段前缩进2字符
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh")
  set par(first-line-indent: 2em)
  show heading: it => {
    it
    fake_par
  }

  // heading，一级标题换页且不显示数字，首行居中
  set heading(numbering: (..nums) => 
    if nums.pos().len() == 1 {
      "实验"+中文数字(nums.pos().first())
    } 
    else {
      nums.pos().slice(0,-1).map(str).join(".")
    }
  )
  show heading: it => {
    set text(font: 字体.黑体)
    if it.level == 1 {
      pagebreak(weak: true)
      align(center)[#text(size: 字号.小二, it)]
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

  set enum(numbering: "1.")

  body
}

#let answer(body) = {
  text(font: 手写字体, body)
}

#show: project.with(
  title: "数字信号处理",
  authors: (
    "absolutex",
  )
)


= 离散时间信号与系统

+ 实验目的
  + 熟悉应用MATLAB表示离散时间信号。
  + 掌握线性卷积求解系统输出的基本方法。
  + 掌握求解离散时间系统输出的方法。
  + 理解采样率变化对信号离散化产生的影响。

+ 实验内容

  + 画出幅度按指数衰减的有限长复指数序列$x(n)=(0.9e^(-0.2 pi j))^n R_(30)(n)$的实部、虚部、幅度和相位。提示：可以调用的函数有exp()、stem()、real()、imag()、abs()、angle()等

    #include_code("数字信号处理/实验代码/1.1.m")
    #figure(
      image("static/1.1.jpg", width:70%),
      caption: [实验结果],
    )

  + 11阶滑动平均系统的输入/输出关系是$y(n)=1/11 sum_(k=0)^10 x(n-k)$，输入信号是 #mi[`x(n)=10 \cos (0.08 \pi n)+w(n)`]，其中$w(n)$是一个在[-5, 5]之间均匀分布的随机序列。试求：
    + 用plot函数在0 ≤ n ≤ 100之间画出输入信号$x(n)$和输出信号$y(n)$
    + 画出$x(n)$的2阶差分信号$v(n)=x(n)-2x(n-1)+x(n-2)$
    + 画出$v(n)$与$w(n)$的相关序列
    + 再产生一个随机序列，画出它与$v(n)$的相关序列。

    #include_code("数字信号处理/实验代码/1.2.m")
    #figure(
      image("static/1.2.jpg", width:100%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：
      + 试分析11阶滑动平均系统的滤波特性。
      #answer[测试]
      + 试分析2阶差分系统的滤波特性。
      + 由3.和4.的实验结果，你得出了什么结论？
  + 下面的差分方程可以产生声音的混响效果，请为音频文件`good.wav`合成混响的效果，并保存在`new_good.wav`文件中。用耳机欣赏混响前的音乐与混响后的音乐有何区别。

    $y(n)=x(n)+alpha x(n-R) "其中, " alpha "<1(比如：α=0.3,R=5000)"$

    #include_code("数字信号处理/实验代码/1.3.m")
    #figure(
      image("static/1.3.jpg", width:70%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：
      + 请问该系统是IIR系统还是FIR系统？
      + 请分析系统的因果性和稳定性在不同的α值和R值（R ≠ ∞）下，系统的因果性和稳定性是否会有变化？
      + 请用文字简要描述不同α值和R值下的混响效果的区别。
  
  + 请编程实现实际音频信号经抽取系统$T[x(2n)]$、$T[x(4n)]$、$T[x(8n)]$后的音效。待处理的音频文件分别为钢琴乐曲卡农片段（canon.wav）和语音片段（dsp.wav）。展示你的程序设计方法并按照要求进行分析。

    #include_code("数字信号处理/实验代码/1.4.m")
    #figure(
      image("static/1.4.jpg", width:100%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：
      + 请比较分析两段乐曲在不同采样率下是否存在失真情况？
      + 请问随着采样率的不断下降，钢琴音频和语音哪一个失真效果更显著？请解释你的结论。

= 离散傅立叶变换与分析

+ 实验目的
  + 熟悉应用MATLAB求解信号频谱的方法。
  + 掌握应用FFT的方法求解系统输出的步骤。
  + 对比分析利用线性卷积求解系统输出和利用FFT方法求解系统输出这两种方法的不同之处。
  + 掌握系统分析方法和简单滤波器的设计方法。

+ 实验内容
  + 设输入信号$x(n)=sin(0.1 pi n)+cos(0.5pi n),0<=n<=199$，某LSI系统的单位脉冲响应为$h(n)=1/4[delta(n)+delta(n-1)+delta(n-2)+delta(n-3)]$，求：
    + 利用线性卷积求输入信号$x(n)$通过系统后的输出$y_1(n)$。
    + 利用FFT的方法，先求解输入信号$x(n)$的频谱$X(k)$以及单位脉冲响应$h(n)$的频谱$H(k)$，通过计算$"IFFT"[X(k) dot H(k)]$求解系统的输出。

    #include_code("数字信号处理/实验代码/2.1.m")
    #figure(
      image("static/2.1.jpg", width:100%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：
      + 请比较两种不同方法求得的输出及其它们的频谱$Y_1(k)$及$Y(k)$；
      + 试分析该系统的滤波特性，并结合输出信号的频率成分进行分析。

  + 已知某系统的系统函数为$H(z)=frac(1+z^(-1)+z^(-2),1+0.9z^(-1)+0.81z^(-2))$，且系统稳定，试求：
    + 求系统的零极点；（提示：可以用tf2zp()函数）
    + 画出系统的零极点图；（提示：可以用zplane()函数）
    + 画出系统的幅频响应、相频响应、群延迟。（提示：可以用freqz()、grpdelay()函数）

    #include_code("数字信号处理/实验代码/2.2.m")
    #figure(
      image("static/2.2.jpg", width:70%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：
      + 试求该系统的ROC，并说明系统的因果性；
      + 试分析该系统的滤波特性；
      + 该滤波器是IIR滤波器还是FIR滤波器？该滤波器具有线性相位吗？

  + 一个LSI系统由下面的差分方程描述：
     $ y(n)+0.8y(n-1)-0.64y(n-2)+0.3125x(n) $
    + 用filter函数计算并画出在$0<=n<=100$内的系统单位脉冲响应，由画出的单位脉冲响应判断系统的稳定性。
    + 画出系统零极点图及系统的幅频和相频响应曲线。
    + 如果这个系统的输入是$x(n)=[5+3cos(pi/3n)]u(n)$，利用filter函数求在$0<=n<=200$内的系统输出。分析输出信号，观察$x(n)$中的直流分量和$pi/3$频率成份分量的通过情况。
    + 如果希望将$x(n)$中的直流分量完全滤除，而$pi/3$频率成份分量仍然保留，应该怎样修改该系统的差分方程，用实验的方法验证你的结论。

    #include_code("数字信号处理/实验代码/2.3.m")
    #figure(
      image("static/2.3.1.jpg", width:70%),
      caption: [第 1-2 题],
    )
    #figure(
      image("static/2.3.2.jpg", width:70%),
      caption: [第 3 题],
    )
    #figure(
      image("static/2.3.3.jpg", width:70%),
      caption: [第 4 题],
    )

    - 实验分析与讨论（请手写）：
      + 请通过实验分析该系统的稳定性；
      + 请分析解释第3问中输入信号不同频率成份的通过情况，并解释原因；
      + 请描述第4问的设计思路。
      $ H(z)&=frac((z-e^(j 0))(z-e^(-j 0)),(z-0.95e^(j 0)(z-0.95e^(-j 0)))) $
      $ &=frac(z^2-2z+1,z^2-1.9z+0.9025) $
      $ &=frac(1-2z^(-1)+z^(-2),1-1.9z^(-1)+0.9025z^(-2)) $

  + 音频文件test1.wav ~ test4.wav中录制了钢琴上的一些按键音，其中，请用FFT的方法识别出每段音频文件中含有那几个音符。（注： (la)=220Hz  (ci)=246.94Hz  (do)=261.63Hz  2(rui)=293.66Hz  3 (mi)=329.63Hz   4(fa)=349.23Hz   5(so)=392Hz ）
    + 请读入test1.wav ~ test4.wav音频文件，画出音频信号的时域图。
    + 请识别test1.wav和test2.wav两个音频文件中弹奏的是哪个音符（请对音频信号中的有效音符区间进行谱分析，建议尝试使用不同的窗函数进行谱分析，以缓解频谱泄漏现象）。
    + 请识别test3.wav和test4.wav两个音频文件中弹奏了哪些音符；
    + （拓展部分）test3.wav和test4.wav两个音频文件有多个音符，且在最后有三音和弦，请尝试切分这些音符，并对其中的单音或和弦进行识别。

    #include_code("数字信号处理/实验代码/2.4.m")
    #figure(
      image("static/2.4.1.jpg", width:90%),
      caption: [时域图],
    )
    #figure(
      image("static/2.4.2.jpg", width:90%),
      caption: [频谱图],
    )

    3-4 题尚未完成。

    