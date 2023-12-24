// typst 0.10.0
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
      nums.pos().slice(1,..).map(str).join(".")
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

= IIR数字滤波器的设计
+ 实验目的
  + 掌握应用MATLAB进行IIR数字滤波器设计的基本方法。
  + 灵活运用MATLAB提供的函数设计各种类型的IIR数字滤波器。

+ 实验内容
  + 已知数字带通滤波器的通带指标为：$omega_(p 1)=0.3pi,omega_(p 3)=0.7pi,alpha_p=0.5"dB"$阻带指标为：$omega_(s 1)=0.2pi,omega_(s 2)=0.8pi, alpha_s=50"dB"$,分别设计满足以上指标的巴特沃斯、切比雪夫I型、切比雪夫II型、以及椭圆数字滤波器，并画出滤波器的频率响应。

    #include_code("数字信号处理/实验代码/3.1.m")
    #figure(
      image("static/3.1.png", width:70%),
      caption: [实验结果],
    )
    - 实验分析与讨论（请手写）：请比较和分析不同类型滤波器在相同技术指标情况下设计出的滤波器阶数、以及滤波器幅频响应的特点。

  + 设计一个数字高通滤波器H(z)，它用在下面的结构中，
    $ x(t) -> A \/ D -> H(z) -> D \/ A -> y(t) $
    满足下列要求：
      + 采样频率为10kHz；
      + 阻带边缘频率为1.5kHz，；
      + 通带边缘频率为2kHz，；
      + 滤波器的幅频响应具有单调的通带和阻带特性。
    画出该数字高通滤波器的频率响应。请自行设计一个输入信号（至少应含有两种及以上的频率成分）通过该滤波器，观察并解释滤波器的输出结果。

    #include_code("数字信号处理/实验代码/3.2.m")
    #figure(
      image("static/3.2.jpg", width:70%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：请写出该滤波器的技术指标，说明设计的输入信号以及实验获得的滤波结果。请预测一下，如果该滤波器用椭圆滤波器来设计，所得到的滤波器阶数应该会变多还是变少？为什么？

  + 已知某系统如图所示
    #figure(image("static/q1.png", width:50%))
    系统的输入x(t)为：
    #figure(image("static/q2.png", width:30%))
    若现在用数字滤波器模拟上述系统的输入输出效果，试求：
    
    + 请选择系统的采样频率fs，画出x(n)；
    + 画出系统的幅频响应$|H(e^(j omega))|$；
    + 画出系统的输出y(n)。

    #include_code("数字信号处理/实验代码/3.3.m")
    #figure(
      image("static/3.3.1.jpg", width:70%),
      caption: [x(n)],
    )
    #figure(
      image("static/3.3.2.jpg", width:70%),
      caption: [幅频响应与相频响应],
    )
    #figure(
      image("static/3.3.3.jpg", width:70%),
      caption: [y(n)],
    )

    - 实验分析与讨论（请手写）：请写出必要的系统分析步骤，分析该滤波器的滤波特性，并解释滤波结果。

= FIR数字滤波器的设计
+ 实验目的
  + 掌握应用MATLAB实现FIR数字滤波器的窗函数设计方法。
  + 掌握应用MATLAB实现FIR数字滤波器的频率采样设计方法。
  + 理解FIR数字滤波器的线性相位约束条件。

+ 实验内容
  + 选择适当的窗函数设计一个数字带阻滤波器，通带指标为：$omega_(p 1)=0.3pi,omega_(p 2)=0.7pi,alpha_p=0.5 "dB"$,阻带指标为：$omega_(s 1)=0.4pi,omega_(s 2)=0.6pi,alpha_s=50 "dB"$,请画出设计的滤波器的脉冲响应和幅频响应。

    #include_code("数字信号处理/实验代码/4.1.m")
    #figure(
      image("static/4.1.jpg", width:100%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：请写出此题选窗的依据，以及滤波器长度的计算方法。另外，此题中对滤波器单位脉冲响应长度的奇偶性是否有要求？为什么？

  + 用频率采样法设计题 1 中的带阻滤波器，选择适当的滤波器阶数，为确保滤波效果，要求过渡带中有两个样本（按照经验值，过渡带两个样本的幅度可以取为0.109和0.594）。请画出设计的滤波器的脉冲响应和幅频响应。

    #include_code("数字信号处理/实验代码/4.2.m")
    #figure(
      image("static/4.2.jpg", width:100%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：请写出应用频域采样法设计该滤波器的方法。
 
  + 用等波纹最佳逼近法设计 1 中的滤波器（注：可以使用remezord()函数和remez()函数，参考第七章讲义例程）。

    #include_code("数字信号处理/实验代码/4.3.m")
    #figure(
      image("static/4.3.jpg", width:70%),
      caption: [实验结果],
    )

    - 实验分析与讨论（请手写）：请比较窗函数法和等波纹最佳逼近法的滤波器阶数和滤波效果。

= 综合实践项目：钢琴乐音识别技术研究

== 实验目的

通过钢琴乐音识别技术的研究，掌握满足复杂工程问题需求的离散时间系统的基本设计方法与分析技术，了解影响设计目标和技术方案的各种因素，并得出有效结论。

== 实验内容

钢琴乐音识别技术对钢琴乐音信号进行基频估计，然后根据基频大小来区分音高，从而实现对乐曲的识别。
课题针对钢琴音频信号进行乐音识别技术的研究。在对音频信号其进行分帧、分音程检测后，对各音程段信号进行离散傅里叶变换，分析频谱中所蕴含的音符信息，并与乐谱进行比对，并得出结论。
请查阅提供的文献资料，并结合自己查阅的资料，完成以下实验内容：

+ 基础要求（必做）：实现不同组别的钢琴音阶识别；
+ 进阶要求（选做）：实现钢琴乐曲《小星星》的整曲识别。
+ 拓展要求（选做）：对钢琴乐曲《小星星》的整曲节奏进行分析评价。

注：2和3至少选做1个。

== 实验报告要求

+ 请写出钢琴乐音识别的技术路线；
  音频采样->时域分析处理->频域分析->谱图表示->音符检测->模式匹配
+ 请阐述钢琴乐音识别的实现步骤；
  + 读入音频文件
  + 用帧峰检测法提取音频的包络信号：对音频信号进行分帧，记录每一帧内的峰峰值，并将每一帧的峰峰值记录在包络数组中
  + 使用滤波算法，对包络信号进行滤波，本实验选择中值滤波
  + 根据包络信号寻找音符的起始点，并去除较小的伪峰点
  + 音程段提取与谱分析：找到每一段的起始位置和终止位置，提取，乘窗函数，添零，再做FFT
  + 音频信号谱图的可视化
  + 画整个音频的短时傅里叶谱图
  + 钢琴音频整曲识别：读入钢琴按键与频率的对应表，将音频幅度矩阵映射到按键矩阵中，画出键号对应的图，显示识别结果
+ 请对实验结果进行分析，并得出自己的结论；

  #figure(
    image("static/5.1.jpg", width:130%),
    caption: [从读取音频到找到音频起始点。plot1：时域图；plot2：包络线；plot3：findpeaks 结果；plot4：去除伪峰点，只保留音符起始位置],
  )
  #figure(
    image("static/5.2.1.jpg", width:100%),
    caption: [逐个音程画图（1-16）],
  )
  #figure(
    image("static/5.2.2.jpg", width:100%),
    caption: [逐个音程画图（17-32）],
  )
  使用音乐小星星画图，数量较多，后面还有一张，这里不放出。
  #figure(
    image("static/5.3.jpg", width:70%),
    caption: [短时傅里叶谱图。上：test_Num=400，中、下：test_Num=4000],
  )
  #figure(
    image("static/5.4.png", width:70%),
    caption: [研究不同帧长下的频谱泄露现象，以帧长400为例。],
  )
  #figure(
    image("static/5.5.jpg", width:70%),
    caption: [钢琴音频节奏评价],
  )

+ 请附上带注释的程序清单。

  寻找音频起始点
  #include_code("数字信号处理/实验代码/5.1.m")
  逐个音程画图，外加没做完的音符识别
  #include_code("数字信号处理/实验代码/5.2.m")
  短时傅里叶谱图
  #include_code("数字信号处理/实验代码/5.3.m")
  不同帧长下的频谱泄露
  #include_code("数字信号处理/实验代码/5.4.m")
  钢琴音频节奏评价
  #include_code("数字信号处理/实验代码/5.5.m")