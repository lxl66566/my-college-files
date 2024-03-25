import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.colors import ListedColormap
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split

data = pd.read_csv("ch3classificationex1.txt", header=None)
X = data.iloc[:, :2].values
y = data.iloc[:, 2].values

# 分割数据集为训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.5, random_state=42
)

# 逻辑斯蒂回归
lr = LogisticRegression()
lr.fit(X_train, y_train)
y_pred_lr = lr.predict(X_test)
print("逻辑斯蒂回归的测试误差：", mean_squared_error(y_test, y_pred_lr))

# LDA
lda = LinearDiscriminantAnalysis()
lda.fit(X_train, y_train)
y_pred_lda = lda.predict(X_test)
print("LDA的测试误差：", mean_squared_error(y_test, y_pred_lda))

# 画图展示结果
cmap_light = ListedColormap(["#FFAAAA", "#AAFFAA"])
cmap_bold = ListedColormap(["#FF0000", "#00FF00"])

plt.figure()
plt.scatter(X_test[:, 0], X_test[:, 1], c=y_test, cmap=cmap_bold, edgecolor="k", s=20)
plt.title("Test data - True labels")
plt.show()

plt.figure()
plt.scatter(
    X_test[:, 0], X_test[:, 1], c=y_pred_lr, cmap=cmap_light, edgecolor="k", s=20
)
plt.title("Test data - Logistic Regression predictions")
plt.show()

plt.figure()
plt.scatter(
    X_test[:, 0], X_test[:, 1], c=y_pred_lda, cmap=cmap_light, edgecolor="k", s=20
)
plt.title("Test data - LDA predictions")
plt.show()
