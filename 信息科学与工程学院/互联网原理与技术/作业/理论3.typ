#import "template.typ": *

#show: project.with(
  title: "理论 3",
  authors: (
    "absolutex",
  )
)

= P1
假设客户A向服务器S发起一个Telnet 会话。与此同时，客户B也向服务器S发起一个Telnet 会话。给出下面报文段的源端口号和目的端口号：

a.从A向S发送的报文段。

#answer([源端口号：随机未被占用；目的端口号：23。])

b.从B向S发送的报文段。

#answer([源端口号：随机未被占用；目的端口号：23。])

c.从S向A发送的报文段。

#answer([源端口号：23；目的端口号：随机未被占用。])

d.从S向B发送的报文段。

#answer([源端口号：23；目的端口号：随机未被占用。])

e.如果A和B是不同的主机，那么从A向S发送的报文段的源端口号是否可能与从B向S发送的报文段的源端口号相同？

#answer([有可能它们的源端口号会相同，因为源端口号是随机选取的。])

f.如果它们是同一台主机，情况会怎么样？

#answer([将相同的源端口号分配给两个报文段])

= P23

主机A和B经一条TCP连接通信，并且主机B已经收到了来自A的最长为126字节的所有字节。假定主机A随后向主机B发送两个紧接着的报文段。第一个和第二个报文段分别包含了80字节和40字节的数据。在第一个报文段中，序号是127，源端口号是302，目的地端口号是80。无论何时主机B接收到来自主机A的报文段，它都会发送确认。

a.在从主机A发往B的第二个报文段中，序号、源端口号和目的端口号各是什么？

#answer([序号：207，源端口号：302，目的地端口号：80。])

b.如果第一个报文段在第二个报文段之前到达，在第一个到达报文段的确认中，确认号、源端口号和目的端口号各是什么？

#answer([确认号：207，源端口号：80，目的地端口号：302。])

c.如果第二个报文段在第一个报文段之前到达，在第一个到达报文段的确认中，确认号是什么？

#answer([128])

d.假定由A发送的两个报文段按序到达B。第一个确认丢失了而第二个确认在第一个超时间隔之后到达。画出时序图，显示这些报文段和发送的所有其他报文段和确认。（假设没有其他分组丢失。）对于图上每个报文段，标出序号和数据的字节数量；对于你增加的每个应答，标出确认号。

#answer([

A->B : Seq=127, Len=126, SrcPort=302, DstPort=80

B->A : Ack=253, SrcPort=80, DstPort=302

A->B : Seq=207, Len=80, SrcPort=302, DstPort=80

(丢失)

A->B : Seq=287, Len=40, SrcPort=302, DstPort=80

B->A : Ack=327, SrcPort=80, DstPort=302

])

= P31

假设测量的5个SampleRTT值（参见3.5.3节）是106ms、120ms、140ms、90ms和115ms。在获得了每个SampleRTT 值后计算 EstimatedRTT，使用$alpha$=0.125并且假设在刚获得前5个样本之后 EstismatedRTT的值为100ms。在获得每个样本之后，也计算DevRTT，假设β=0.25，并且假设在刚获得前5个样本之后DevRTT的值为5ms。最后，在获得这些样本之后计算TCP Timeoutnterval。

#answer([

$"EstimatedRTT" = (1 - alpha) \* "EstimatedRTT" + alpha \* "SampleRTT"$

$"DevRTT" = (1 - beta) \* "DevRTT" + beta \* |"SampleRTT" - "EstimatedRTT"|$

EstimatedRTT_1 = 101.25ms

EstimatedRTT_2 = 103.56ms

EstimatedRTT_3 = 107.07ms

EstimatedRTT_4 = 100.95ms

EstimatedRTT_5 = 103.73ms

DevRTT_1 = 3.68ms

DevRTT_2 = 9.77ms

DevRTT_3 = 18.11ms

DevRTT_4 = 14.93ms

DevRTT_5 = 17.33ms


TimeoutInterval = 103.73ms + 4 \* 17.33ms = 174.02ms

])
= P40

考虑图3-61。假设TCP Reno是一个经历如上所示行为的协议，回答下列问题。在各种情况中，简要地论证你的回答。

a.指出TCP慢启动运行时的时间间隔。

#answer([$6-1=5"ms"$])

b.指出TCP拥塞避免运行时的时间间隔。

#answer([$16-6=10"ms"$])

c.在第16个传输轮回之后，报文段的丢失是根据3个冗余ACK还是根据超时检测出来的？

#answer([冗余 ACK])

d.在第22个传输轮回之后，报文段的丢失是根据3个冗余ACK还是根据超时检测出来的？

#answer([超时])

e.在第1个传输轮回里，ssthresh的初始值设置为多少？

#answer([$42/2=21"ms"$])

f.在第18个传输轮回里，ssthresh的值设置为多少？

#answer([$29/2=14.5"ms"$])

g.在第24个传输轮回里，ssthresh的值设置为多少？

#answer([$21"ms"$])

h.在哪个传输轮回内发送第70个报文段？

#answer([27传输轮回])

i.假定在第26个传输轮回后，通过收到3个冗余ACK检测出有分组丢失，拥塞的窗口长度和ssthresh的值应当是多少？

#answer([cwnd: $8/2+3=7$；ssthresh: $8/2=4$])

j.假定使用TCP Tahoe（而不是TCP Reno），并假定在第16个传输轮回收到3个冗余ACK。在第19个传输轮回，ssthresh和拥塞窗口长度是什么？

#answer([cwnd: $4$；ssthresh: $8/2=4$])

k.再次假设使用TCP Tahoc，在第22个传输轮回有一个超时事件。从第17个传输轮回到第22个传输轮回（包括这两个传输轮回），一共发送了多少分组？

#answer([6个])