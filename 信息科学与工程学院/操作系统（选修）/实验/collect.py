# 用于多次运行结果统计

from collections import defaultdict
from subprocess import run

result = defaultdict(lambda: 0)

try:
    for i in range(0, 100):
        ret = run("xmake r", shell=True, capture_output=True)
        result[ret.stdout] += 1
finally:
    for k, v in result.items():
        print(f"{k.decode()}: {v}")
