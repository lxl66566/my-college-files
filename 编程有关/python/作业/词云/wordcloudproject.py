import jieba
import numpy as np
from PIL import Image
from wordcloud import WordCloud

def cut(txt):
  words = jieba.lcut(txt)
  newtxt = ''.join(words)
  return newtxt


with open('YongAn.txt','r',encoding = 'utf-8') as f:
    txt = f.read()
txt = cut(txt)
mask = np.array(Image.open("YongAn.png"))
wordcloud = WordCloud(background_color="white",
                      width = 800,
                      height = 600,
                      max_words = 200,
                      max_font_size = 80,
                      mask = mask,
                      contour_width = 4,
                      contour_color = 'steelblue',
                        font_path =  "msyh.ttc"
                      ).generate(txt)
wordcloud.to_file('wordcloud_YongAn.png')