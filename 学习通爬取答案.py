from fileinput import filename
import img2pdf
import requests
from io import BytesIO

url = 'https://d.e.ecust.edu.cn/doc/e6/8ee8c4d143c78c9bc06112c1ad16e484/thumb/'

ans = url    # 选用哪一个url
pagesnum = 8    # 答案页数
filenme = '8.pdf'  # 导出文件名

with open(filenme, "wb") as f:
    temp = []
    for i in range(1,pagesnum + 1):
        response = requests.get(ans + str(i) + '.png')
        temp.append(BytesIO(response.content))
    write_content = img2pdf.convert(temp)
    f.write(write_content)
print("convert completed")