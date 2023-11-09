#import "../template.typ": *

#show: project.with(
  title: "实践 3：Wireshark实验——TCP",
  authors: (
    "absolutex",
  )
)

= 内容

捕获从计算机到远程服务器的批量 TCP 传输。访问一个网页，考察该访问过程中的TCP传输过程。

== 客户端计算机(源)使用的 IP 地址和 TCP 端口号是什么?服务器IP 地址是什么? 在哪个端口号上发送和接收此连接的 TCP 段? 

#figure(
  image("20231109-09.33.png", width: 100%),
)

客户端IP：192.168.1.106，TCP端口号：57998

服务端IP：101.89.125.187，TCP端口号：443

== 启动 TCP 连接的 TCP SYN 段的序列号是什么? 

#figure(
  image("20231109-09.43.png", width: 100%),
)

949402233

== 发送给客户端计算机以回复 SYN 的 SYNACK 段的序号、ack号分别是多少? SYNACK 段中的 Acknowledgment 的值是多少? 

#figure(
  image("20231109-09.48.png", width: 100%),
)
#figure(
  image("20231109-1425.png", width: 100%),
  caption: [补图]
)

SYNACK 段的序号：1

ack号：1

SYNACK 段中的 Acknowledgment 的值是 1

== 包含 HTTP POST 命令的 TCP 段的序号是多少? 

#figure(
  image("20231109-09.55.png", width: 100%),
)

不包含 HTTP POST 命令。

== 估算RTT是多少？

#figure(
  image("20231109-10.00.png", width: 100%),
)

首个客户端分组时间戳：2.152433166

#figure(
  image("20231109-10.01.png", width: 100%),
)

首个服务端分组时间戳：2.159949756

$$RTT = (2.159949756 - 2.152433166) / 2 = 0.00752 s$$