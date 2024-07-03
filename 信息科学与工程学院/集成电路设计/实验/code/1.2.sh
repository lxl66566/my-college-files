cd /home/my_work
touch my_doc.txt
chmod +rw my_doc.txt
man pwd | sed 's/\x1b\[[0-9;]*m//g' > my_doc.txt # sed 用于清除加粗与颜色编码，获取纯净的 man 输出
vi my_doc.txt   # 或者使用 vim
:set number
ggO## It is the explanation of pwd command
<ESC>:3,5g/^$/d
ggyy:51<ENTER>p
:s/pwd/PWD/g<ENTER>
:wq
wget https://cs.e.ecust.edu.cn/download/357305b7bb197fe135307010f3d90e95 -O cmp.txt # 下载
diff cmp.txt my_doc.txt