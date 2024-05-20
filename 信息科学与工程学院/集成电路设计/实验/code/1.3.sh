vim /home/vlsi/.bashrc
alias sudir='sudo mkdir'
export MYWORK_DIR=/home/my_work
:wq
cd /home
sudir my_test
echo $MYWORK_DIR
ls /home