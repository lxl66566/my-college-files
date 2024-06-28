#!/bin/env python3

# 画图

import matplotlib.pyplot as plt

x = range(0, 42, 2)

y0 = [80, 78, 74, 68, 59, 51, 42, 32, 21, 14, 10, 6, 4, 2, 2, 2, 1, 1, 0, 0, 0]

y90 = [80, 77, 71, 63, 52, 39, 27, 16, 9, 5, 3, 1] + [0] * 9

fig, (ax1, ax2) = plt.subplots(2, 1)

# 在第一个子图上绘制 y1
ax1.plot(x, y0)
ax1.set_title('φ=0')  # 设置标题
ax1.set_xlabel('θ')  # 设置 x 轴描述
ax1.set_ylabel('φ')  # 设置 y 轴描述

# 在第二个子图上绘制 y2
ax2.plot(x, y90)
ax2.set_title('φ=90')  # 设置标题
ax2.set_xlabel('θ')  # 设置 x 轴描述
ax2.set_ylabel('φ')  # 设置 y 轴描述

# 显示图形
plt.tight_layout()
plt.show()