import img2pdf
import requests
from io import BytesIO

url = [
    'http://d.e.ecust.edu.cn/doc/bc/9213e804a416702a7e814060301016a2/thumb/',
    'http://d.e.ecust.edu.cn/doc/ea/4d20ebe2cc3c049cfc49487b2e1a4432/thumb/',
    'http://d.e.ecust.edu.cn/doc/53/cd059bc1ea7d043879768e7aeb84a02d/thumb/',
    ]

ans = url[2]    # 选用哪一个url
pagesnum = 7    # 答案页数

with open('第三册答案.pdf', "wb") as f:
    temp = []
    for i in range(1,pagesnum + 1):
        response = requests.get(ans + str(i) + '.png')
        temp.append(BytesIO(response.content))
    write_content = img2pdf.convert(temp)
    f.write(write_content)
print("convert completed")