#coding=utf-8
from qrcode import *
q = QRCode()
q.add_data('21012792刘宣乐18259734087 邮箱1421962366@qq.com')
q.make()
img = q.make_image()
img.show()
