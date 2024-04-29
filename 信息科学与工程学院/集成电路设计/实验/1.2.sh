cd /home/my_work
touch my_doc.txt
chmod +rw my_doc.txt
man pwd > my_doc.txt
vi my_doc.txt   # 或者使用 vim
:set number
ggO## It is the explanation of pwd command
<ESC>:3,5g/^$/d
ggyy:51<ENTER>p
:s/pwd/PWD/g<ENTER>
:wq
diff cmp.txt my_doc.txt