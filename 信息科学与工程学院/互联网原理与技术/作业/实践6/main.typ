#import "../../../template.typ": *

#show: project.with(
  title: "实践 6",
  authors: (
    "absolutex",
  )
)

= 实践作业6

== Wireshark 以太网实验：Wireshark 数据包捕获: 访问www.tsinghua.edu.cn

=== 选择包含 HTTP GET 消息的以太网帧。根据包含 HTTP GET 消息的以太网帧的内容回答以下问题。在回答问题时，应该在用于回答所提问题的跟踪中提交数据包的打印输出。注释打印输出以解释您的答案。

实际上，并没有找到 HTTP GET 消息中有 Ethernet II 的帧。


#figure(
  image("ethernet not found.png", width: 95%),
  caption: "ethernet not found"
)

==== 您的计算机的 48 位以太网地址是什么？ 

#figure(
  image("get.png", width: 95%),
  caption: "get"
)

`00:93:37:f8:27:df`

==== 以太网帧中的 48 位目标地址是什么？

在 GET 请求中，没有找到 48 位目标地址。

==== 这是 www.tsinghua.edu.cn 的以太网地址吗？什么设备将此作为其以太网地址？

不是，是上游设备（路由器）的以太网地址。

==== 为双字节帧类型字段指定十六进制值。 这对应于什么上层协议？ 从以太网帧的开头开始，“GET”中的 ASCII“G”出现在以太网帧中多少字节？

#figure(
  image("protocol.png", width: 95%),
  caption: "frame structure"
)

对应于 IPv6 协议。`Protocol: IPv6 (0x86dd)`

#figure(
  image("frame.png", width: 95%),
  caption: "frame structure"
)

第 89 字节。

=== 根据包含 HTTP 响应消息第一个字节的以太网帧回答以下问题。 
==== 以太网源地址的值是多少？ 这是您的计算机地址，还是 www.tsinghua.edu.cn的地址。 什么设备将此作为其以太网地址？

#figure(
  image("response.png", width: 95%),
  caption: "response"
)

`30:7b:ac:1a:f0:02`

是 www.tsinghua.edu.cn 的地址。路由器将其作为其以太网地址。

==== 以太网帧中的目标地址是什么？ 这是您计算机的以太网地址吗？ 

同样，找不到以太网帧中的目标地址。

==== 为双字节帧类型字段指定十六进制值。这对应于什么上层协议？ 

同样，对应的 IPv6 协议。

==== 从以太网帧的一开始，“OK”中的 ASCII“O”（即 HTTP 响应代码）出现在以太网帧中多少字节？

响应是 `HTTP/1.1 302 Found\r\n`，出现在第 89 字节。

== Wireshark ARP实验：清除本机ARP缓存。 确保浏览器的缓存为空。启动 Wireshark 数据包嗅探器，访问www.Tsinghua.edu.cn。停止 Wireshark 数据包捕获。回答问题： 

#figure(
  image("ARP.png", width: 95%),
  caption: "ARP"
)

=== 包含 ARP 请求消息的以太网帧中源地址和目标地址的十六进制值是什么？ 

源：`fc:d7:33:01:5d:a0`

目标：`00:00:00:00:00:00`

=== 为双字节以太网帧类型字段提供十六进制值。 这对应于什么上层协议？ 

ARP 协议（`Protocol: ARP (0x0806)`）

=== 包含 ARP 回复消息的以太网帧中的源地址和目标地址的十六进制值是什么？

没有回复。