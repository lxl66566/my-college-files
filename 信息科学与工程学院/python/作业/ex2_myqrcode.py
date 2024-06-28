#coding=utf-8
from qrcode import *
q = QRCode()
q.add_data('12456')
q.make()
img = q.make_image()
img.show()
