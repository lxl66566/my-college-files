from statistics import mean

import networkx as nx
import pandas as pd

adjacency_matrix = pd.read_excel(r"Z:\archive\Twitter_Data.xlsx", index_col=0)
G = nx.from_pandas_adjacency(adjacency_matrix)
degree_centrality = mean(nx.degree_centrality(G).values())
clustering_coefficient = nx.average_clustering(G)
betweenness_centrality = nx.betweenness_centrality(G)
average_shortest_path_length = nx.average_shortest_path_length(G)
print("网络度：", degree_centrality)
print("聚集系数：", clustering_coefficient)
print("介数中心性：", mean(betweenness_centrality.values()))
print("平均路径长度：", average_shortest_path_length)
if clustering_coefficient > 0.1:
    print("该网络属于小世界网络")
elif degree_centrality > 2:
    print("该网络属于无标度网络")
else:
    print("该网络属于随机复杂网络")

# Facebook_Data
# 网络度：0.10040640640640641
# 聚集系数：0.10032958844523898
# 介数中心性：0.0009014345006328968
# 平均路径长度：1.8996316316316317
# 该网络属于小世界网络

# Instagram_Data
# 网络度：0.009875875875875876
# 聚集系数：0.009066096931963806
# 介数中心性：0.0022776925221815
# 平均路径长度：3.273137137137137
# 该网络属于无标度网络

# Twitter_Data
# 网络度：0.5011311311311312
# 聚集系数：0.50120995714053
# 介数中心性：0.0004998686060810305
# 平均路径长度：1.498868868868869
# 该网络属于小世界网络
