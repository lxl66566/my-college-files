from ping3 import ping, verbose_ping

target_host = "baidu.com"
response = ping(target_host)
print(f"Ping {target_host}: {response} ms")

verbose_ping(target_host, count=4, interval=1, timeout=2)
