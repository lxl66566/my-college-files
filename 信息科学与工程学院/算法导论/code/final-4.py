from collections import Counter

import matplotlib.pyplot as plt
import networkx as nx


def calculate_degree(graph):
    degrees = dict(graph.degree())
    average_degree = sum(degrees.values()) / len(graph)
    return degrees, average_degree


def calculate_degree_distribution(graph):
    degrees = dict(graph.degree())
    degree_counts = Counter(degrees.values())
    total_nodes = len(graph)

    degree_distribution = {k: v / total_nodes for k, v in degree_counts.items()}
    return degree_distribution


def main():
    sample_graph = nx.Graph()
    sample_graph.add_edges_from([(1, 2), (1, 3), (2, 3), (2, 4), (3, 4), (4, 5)])

    degrees, avg_degree = calculate_degree(sample_graph)
    degree_distribution = calculate_degree_distribution(sample_graph)

    print("网络的度：", degrees)
    print("网络的平均度：", avg_degree)
    print("网络的度分布：", degree_distribution)

    plt.figure(figsize=(8, 6))
    nx.draw(
        sample_graph,
        with_labels=True,
        font_weight="bold",
        node_size=800,
        node_color="skyblue",
    )
    plt.title("Network Visualization")
    plt.show()


if __name__ == "__main__":
    main()

# 网络的度： {1: 2, 2: 3, 3: 3, 4: 3, 5: 1}
# 网络的平均度：2.4
# 网络的度分布： {2: 0.2, 3: 0.6, 1: 0.2}
