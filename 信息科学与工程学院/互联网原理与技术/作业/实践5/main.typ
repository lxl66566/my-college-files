#import "../../../template.typ": *

#show: project.with(
  title: "实践 5",
  authors: (
    "absolutex",
  )
)

= 内容

== 编程实现ICMPping

#include_code_file("互联网原理与技术/作业/实践5/ICMPping.py","ICMPping.py","python")

输出：
```
Ping baidu.com: 0.030469417572021484 ms
ping 'baidu.com' ... 29ms
ping 'baidu.com' ... 29ms
ping 'baidu.com' ... 28ms
ping 'baidu.com' ... 30ms
```

== Wireshark实验：考察在 ping和 Traceroute命令中 ICMP协议的使用 

=== 捕获 Ping 程序生成的数据包 ，回答： 
#figure(
  image("20231208-10.47.png", width: 100%),
)
1. 您的主机的 IP 地址是多少? 目标主机的 IP 地址是多少?

主机：10.102.177.73  目标主机：110.242.68.66

2. 为什么 ICMP 数据包没有源端口号和目的端口号? 

ICMP主要用于网络设备之间的通信，例如在主机和路由器之间传递错误消息或控制信息。因此，ICMP消息被直接封装在IP包内，而不需要端口号。

3. 查看任意的请求 ICMP 数据包， ICMP 类型和代码是什么? 

类型：`(8) Echo (ping) request`   代码：`0`

4. 该 ICMP 数据包还有哪些其他字段? 校验和，序列号和标识符字段有多少字节? 

还有这些其他字段：
```
Checksum: 0xb0e1 [correct]
Identifier (BE): 11 (0x000b)
Identifier (LE): 2816 (0x0b00)
Sequence Number (BE): 0 (0x0000)
Sequence Number (LE): 0 (0x0000)
Data (56 bytes)
```
校验和，序列号和标识符字段各有 2 字节

=== 捕获 Traceroute 程序生成的数据包 。

#figure(
  image("20231208-11.06.png", width: 100%),
)
在 Unix / Linux 中，路由跟踪 traceroute 使用发送不可到达(无使用的)端口的 UDP 包来实现，在 Windows 中，路由跟踪 tracert 仅使用 ICMP 数据包来实现 

1. 发送了 UDP 数据包(如在 Unix / Linux 中)，那么探测数据包的 IP 协议号仍然是 01 吗? 如果没有，它会是什么? 

不是，是 17

2. 检查ICMP 响应数据包。 这与本实验的前半部分中的 ICMP ping 查询数据包不同吗? 如果不同，请解释为什么? 

IP 信息包含在 ICMP 内。因为 traceroute 利用 ICMP 错误消息来实现路由跟踪的功能。

3. 检查源主机收到的最后三个ICMP 数据包。这些数据包与 ICMP 错误数据包有何不同? 他们为什么不同? 

最后三个 ICMP 数据包是 `Type: 3 (Destination unreachable)`，ICMP 端口不可达消息，而其余的数据包通常是 ICMP 时间超时消息