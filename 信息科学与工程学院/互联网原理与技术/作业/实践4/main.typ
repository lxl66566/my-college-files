#import "../template.typ": *

#show: project.with(
  title: "实践 4：Wireshark实验——IP",
  authors: (
    "absolutex",
  )
)

= 内容

== 分析traceroute时的IP包格式。

运行 traceroute 并让它发送各种长度的数据报。Linux/Unix/MacOS ： traceroute 用UDP 数据报 

Traceroute指定包长度：一个长度 为 56 个字节，一个长度为 2000 个字节，另一个长度为 3500 个字节。 

```
traceroute www.bilibili.com 56
traceroute to www.bilibili.com (114.230.222.139), 30 hops max, 56 byte packets
1  _gateway (192.168.1.1)  0.131 ms  0.125 ms  0.106 ms
2  254.111.165.61.dial.xw.sh.dynamic.163data.com.cn (61.165.111.254)  0.499 ms  0.480 ms  0.565 ms
3  192.168.243.1 (192.168.243.1)  3.604 ms  4.057 ms  4.521 ms
4  124.74.148.249 (124.74.148.249)  1.509 ms 124.74.148.245 (124.74.148.245)  1.656 ms 124.74.34.209 (124.74.34.209)  1.799 ms
5  124.74.210.69 (124.74.210.69)  3.082 ms 124.74.210.37 (124.74.210.37)  2.290 ms124.74.210.69 (124.74.210.69)  3.078 ms
6  61.152.25.18 (61.152.25.18)  2.886 ms 61.152.26.46 (61.152.26.46)  2.338 ms 61.152.24.126 (61.152.24.126)  3.551 ms
7  202.97.72.158 (202.97.72.158)  12.988 ms 202.97.29.110 (202.97.29.110)  8.141 ms *
8  * * *
9  * * *
10  * * *
11  * * *
12  * * 114.230.222.139 (114.230.222.139)  9.660 ms
```

其他大小的输出类似。

#figure(
  image("20231123-09.32.png", width: 100%),
)

=== 在 IP header 中，上层协议字段的值是多少? 

Protocol: UDP (*17*)

=== IP header 有多少 bytes? IP datagram 的有效负载中有多少 bytes? 

0101 = Header Length: *20 bytes* (5)

=== 此 IP 数据报是否已被分段(fragmented)?  

010. .... = Flags: 0x2, Don't fragment
> .1.. .... = *Don't fragment: Set*

未被分段。

=== ID 字段和 TTL 字段的值是多少? 

ID: 10755  TTL: 64

=== 将 pingplotter 数据包大小更改为 2000 后，查找计算机发送的第一个 ICMP Echo Request 消息。该消息是否已碎片化为多个 IP 数据报? 

#figure(
  image("20231123-12.15.png", width: 100%),
)

并没有被分段。

== 分析web（https和http）访问时的IP包格式

运行 web访问，分别查看http/https请求和响应。

#figure(
  image("20231123-12.20.png", width: 80%),
  caption: "http"
)
#figure(
  image("20231123-12.27.png", width: 80%),
  caption: "https"
)

=== 在 IP header 中，上层协议字段的值是多少? 

6


=== IP header 有多少 bytes?

20 

=== 查看响应数据包已碎片化为多个 IP 数据报? 

没有

== 分析通过dhcp分配IP地址的过程，给出传输数据包的结构，包括源目的端口、IP、MAC地址、包的内容

`sudo dhclient -r`

#figure(
  image("20231123-12.44.png", width: 100%),
)

客户端：192.168.1.106:68, mac: Clevo_15:76:cd (d4:93:90:15:76:cd)

服务端：192.168.1.1:67, mac: TpLinkTechno_01:5d:a0 (fc:d7:33:01:5d:a0)

内容：

#figure(
  image("20231123-12.50.png", width: 100%),
)