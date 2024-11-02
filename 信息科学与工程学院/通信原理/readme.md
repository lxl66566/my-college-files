# 通信原理

教师：袁伟娜。语速快，比较喜欢聊天，跟同学相处不错。但是教学方法，包括[实验态度](./实验/readme.md)，我不是很赞同。

## 个人资料

[我的博客](https://absx.pages.dev/learning/PoC.html)里有通信原理的笔记。

## 2024 考题回忆版

背了一大堆误码率公式，结果发现基本都不考。

填空 25 题 \* 1 分，判断 10 题 \* 0.5 分，计算 70 分

### 填空

1. 时分复用，码分复用，频分复用
2. A 律 13 折线（唯一一题）
3. PCM 抽样，已知信号频率，求最低用多少抽样；如果用 xxx 抽样，计算 $R_B$。
4. 写出香农公式和其物理意义
5. 给出了信道带宽 6kHz 和信噪比 63，求传码速率和误信率？
6. 数字调制相比模拟调制的缺点，除了占用频带宽，还有\_\_\_\_。
7. 高斯白噪声里的 _高斯_ 是什么意思，_白_ 是什么意思。
8. ...

### 判断

1. 预编码的作用是人为引入码间干扰。
2. 某个编码是否是原编码的 HDB3 编码。（注意，解调后能够恢复为原编码，不代表其为正确的 HDB3 编码）
3. ...

### 计算

1. DSB 和 SSB 的计算与对比。
   - 求 SSB 带通滤波器中心频率，带宽
   - 如果要求误码率相同，输入信号功率之比需要是多少？
2. 时分复用，0.5KHz \* 2, 1KHz \* 2, 2KHz \* 2, 3kHz \* 2，求帧长，时隙个数，宽度；PCM 8 位量化电平求总码元速率...。
3. 匹配滤波器，画系统框图，两个系统函数，两个码元经过系统函数的波形。
4. PCM 编码 + 余弦 0.25 滚降 + 2PSK，求各种带宽，输出 $R_B$，频带利用率，...；
   - 假如把 2PSK 换成 16QAM，求 $R_B$，频带利用率。
5. 2ASK，画波形，调制解调框图，噪声性能分析全过程
6. 脉冲振幅调制 PAM 单位冲激响应，画波形。基本算是信号与系统送分。<https://cs.e.ecust.edu.cn/download/ea2e8918ea98b312777e7ce1e589f987> 第 91-92 页的原题。

## 官方资料

PPT 课件，乱序

```
https://cs.e.ecust.edu.cn/download/2c08c9de7f907e647270cf2e3f58547d
https://cs.e.ecust.edu.cn/download/c8ada414b275be2e6a7b58390931e6ff
https://cs.e.ecust.edu.cn/download/29b2f377719331f7d713b8612da9b903
https://cs.e.ecust.edu.cn/download/88119d88a38855531d6347a9bf96a3f6
https://cs.e.ecust.edu.cn/download/ecca3fed4a2cd257c5d3e21e5e6e2e5a
https://cs.e.ecust.edu.cn/download/ea2e8918ea98b312777e7ce1e589f987
https://cs.e.ecust.edu.cn/download/d542351cc24fe5b9c46dabac96dc6c4b
https://cs.e.ecust.edu.cn/download/e10c6a6c4edd1697d49170dc9caaebcf
https://cs.e.ecust.edu.cn/download/326bba328bacc6087f037b5ad98f67b9
https://cs.e.ecust.edu.cn/download/8e7a98b6f99253a8292f6e6c5cdaee39

https://cs.e.ecust.edu.cn/download/c7ed2b595bb761eec4b1965181ed8b3d
https://cs.e.ecust.edu.cn/download/3238973e4eeaba8f9faf05c98555c08d
https://cs.e.ecust.edu.cn/download/5c63ac9674ec3c50bd96aa3303e96beb
https://cs.e.ecust.edu.cn/download/d284849c170d5ec245d2b4a362412b7e
https://cs.e.ecust.edu.cn/download/151045d271cf501546676ea3e6283c91
https://cs.e.ecust.edu.cn/download/9528506fce081d30224efb740710ab0c
https://cs.e.ecust.edu.cn/download/63dfcc4571a7d563764211a985adb188
https://cs.e.ecust.edu.cn/download/bc9f726f1d27b004687efe0b6fc26534
https://cs.e.ecust.edu.cn/download/c7270546612753a5efd345ec6d05d622
https://cs.e.ecust.edu.cn/download/1a904289eba53d9644fe8e7caa2bb1b5

https://cs.e.ecust.edu.cn/download/0db3057e67c268b9770aefdab98fa6a4
https://cs.e.ecust.edu.cn/download/7d4031235955b7b855fa37802bf0c890
```
