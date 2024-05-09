import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report

# 读取数据集
data = pd.read_csv('MNIST.train.csv')

# 提取特征和标签
X = data.iloc[:, 1:]  # 特征
y = data.iloc[:, 0]   # 标签

# 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=30)

# 创建MLP模型
# 单隐层：
# mlp = MLPClassifier(hidden_layer_sizes=(100,), activation='relu', solver='adam', max_iter=100)
# 三隐层：
mlp = MLPClassifier(hidden_layer_sizes=(100, 50, 20), activation='relu', solver='adam', max_iter=100)

# 训练模型
mlp.fit(X_train, y_train)

# 预测
y_pred = mlp.predict(X_test)

# 评估模型性能
accuracy = accuracy_score(y_test, y_pred)
print(f"Accuracy: {accuracy:.2f}")

# 输出分类报告
print(classification_report(y_test, y_pred))

# 可视化前几个手写数字图像
for i in range(5):
    image = X_train.iloc[i].values.reshape(28, 28)
    plt.imshow(image, cmap='gray')
    plt.title(f"Label: {y_train.iloc[i]}")
    plt.show()
