import matplotlib.pyplot as plt
from matplotlib import font_manager

fontP = font_manager.FontProperties()
fontP.set_family("SimHei")
fontP.set_size(14)

s = """|0|4.7| |110| 108.5| |
|10| 12.9| |120| 118.4| |
|20| 23.0| |130| 127.9| |
|30| 31.6| |140| 137.7| |
|40| 41.2| |150| 147.1| |
|50| 52.5| |160| 157.5| |
|60| 61.9| |170| 170.6| |
|70| 71.7| |180| 180.0| |
|80| 81.2| |190| 190.4| |
|90| 90.5| |200| 199.9| |
|100| 98.9| | | | |"""

d = dict()
data2 = dict()
ans = []
for line in s.splitlines():
    i = line.strip().strip("|").split("|")
    d[int(i[0])] = float(i[1].strip())
    data2[int(i[0])] = abs(float(i[1].strip()) - int(i[0]))
    i[2] = "{:.1f}".format(data2[int(i[0])])
    if i[3].strip():
        d[int(i[3])] = float(i[4].strip())
        data2[int(i[3])] = abs(float(i[4].strip()) - int(i[3]))
        i[5] = "{:.1f}".format(data2[int(i[3])])
    ans.append("|" + "|".join((map(str, i))) + "|")
print("\n".join(ans))

plt.plot(*zip(*sorted(d.items())))
plt.xlabel("输入信号有效值(mV)", fontproperties=fontP)
plt.ylabel("显示电压有效值(mV)", fontproperties=fontP)
plt.show()

plt.plot(*zip(*sorted(data2.items())))
plt.xlabel("输入信号有效值(mV)", fontproperties=fontP)
plt.ylabel("误差(mV)", fontproperties=fontP)
plt.show()
