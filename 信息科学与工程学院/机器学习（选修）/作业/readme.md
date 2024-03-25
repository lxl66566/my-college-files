# 作业

我不使用 matlab，全部使用 python。包管理是 poetry。

## Project 1

描述：给定 ch3classificationex1.txt 数据集，如：前两列表示成绩属性，最后一列为是否获得奖学金，
以此数据集进行 0，1 分类。

要求：
1 运用逻辑斯蒂回归，获得模型模型参数，可以 50%训练，50%测试。给出测试误差，画图展示结
果。
选作：2 利用 LDA 模型进行分类训练，可以 50%训练，50%测试。给出测试误差，画图展示结果。
提交：代码文件，即.py 或.m

文档文件：包含代码、结果和图示及分析等。

若 2 个程序用了两个代码文件可以分别提交。

说明：编程语言不限

Python 可以参考逻辑回归例程。如果用 LDA 模型的 Sklearn 库为：

```python
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
```

逻辑斯蒂回归关键函数如下，也可以根据算法直接编程实现。

```matlab
a =glmfit(X,y,'binomial', 'link', 'logit');%用逻辑回归来计算系数矩阵,这是系统自带函数
logitFit = glmval(a,X_test, 'logit'); %用逻辑回归的结果预测测试集的结果
```

### 资料

数据集：

```
https://mooc.s.ecust.edu.cn/ueditorupload/read?objectId=a3c7a9a81be9bcdffed66b328cc04377
```

要求：

```
https://mooc.s.ecust.edu.cn/ueditorupload/read?objectId=d1f77869cf9b3638b39fdce15af91a32
```
