from fileinput import filename
import img2pdf
import requests
from io import BytesIO

url = 'http://d.e.ecust.edu.cn/doc/e9/507c9cfa6629829b1c9f72c065880476/thumb/'

ans = url    # 选用哪一个url
pagesnum = 53    # 答案页数
filenme = '第9章 静电场中的导体和电介质.pdf'  # 导出文件名

with open(filenme, "wb") as f:
    temp = []
    for i in range(1,pagesnum + 1):
        response = requests.get(ans + str(i) + '.png')
        temp.append(BytesIO(response.content))
    write_content = img2pdf.convert(temp)
    f.write(write_content)
print("convert completed")