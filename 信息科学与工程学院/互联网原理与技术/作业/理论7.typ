#import "../../template.typ": *
#import "@preview/tablem:0.1.0": tablem


#show: project.with(
  title: "理论 7",
  authors: (
    "absolutex",
  )
)
#set heading(numbering: none)

// P3、P7

= 理论作业7

== P3 假设图7-6中的接收方希望接收由发送方2发送的数据。说明通过使用发送方2的代码，（经计算）接收方的确能够将发送方2的数据从聚合信道信号中恢复出来。

$d_1^2=（0+2+0+2+0+0+2+2）/8=1$

$d_2^2=（2+0+2+0+2+2+0+0）/8=1$

== P7 假设一个802.11b站点被配置为始终使用RTS/CTS序列预约信道。假设该节点突然要发送1500字节的数据，并且所有其他站点此时都是空闲的。作为SIFS和DIFS的函数，忽略传播时延并假设无比特差错，计算发送该帧和收到确认需要的时间。

$T_总=T_"DIFS"+ 3T_"SIFS"+ T_"RTS"+ T_"CTS"+T_"DATA"+ T_"ACK"$