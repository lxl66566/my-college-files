from math import cos, pi
from matplotlib.pyplot import *

figure(figsize=(9,3),dpi=120)
l = []
r = []
i = 0
while i <= 2 * pi:
    l.append(i)
    r.append(cos(i))
    i += 0.01
clf()
plot(l,r)
xlabel('x')
ylabel('cos x')
show()