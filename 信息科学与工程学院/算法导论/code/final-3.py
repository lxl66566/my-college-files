import matplotlib.pyplot as plt
import networkx as nx


def clustering_coefficient_undirected(graph, node):
    neighbors = set(graph[node])
    total_possible_edges = len(neighbors) * (len(neighbors) - 1) / 2

    if total_possible_edges == 0:
        return 0

    actual_edges = 0
    for neighbor1 in neighbors:
        for neighbor2 in neighbors:
            if neighbor1 != neighbor2 and graph.has_edge(neighbor1, neighbor2):
                actual_edges += 1

    clustering_coefficient = actual_edges / total_possible_edges
    return clustering_coefficient


def clustering_coefficient_directed(graph, node):
    out_degree = graph.out_degree(node)

    if out_degree <= 1:
        return 0

    actual_edges = 0
    for neighbor1 in graph.successors(node):
        for neighbor2 in graph.successors(node):
            if neighbor1 != neighbor2 and graph.has_edge(neighbor1, neighbor2):
                actual_edges += 1

    total_possible_edges = out_degree * (out_degree - 1)
    clustering_coefficient = actual_edges / total_possible_edges
    return clustering_coefficient


def average_clustering_coefficient(graph, is_directed=False):
    total_coefficient = 0
    nodes_count = len(graph)

    for node in graph.nodes():
        if is_directed:
            total_coefficient += clustering_coefficient_directed(graph, node)
        else:
            total_coefficient += clustering_coefficient_undirected(graph, node)

    average_coefficient = total_coefficient / nodes_count
    return average_coefficient


def main():
    undirected_graph = nx.Graph()
    undirected_graph.add_edges_from(
        [(1, 2), (1, 3), (2, 3), (2, 4), (3, 4), (4, 5), (5, 1)]
    )

    print("无向图的聚集系数：")
    for node in undirected_graph.nodes():
        coefficient = clustering_coefficient_undirected(undirected_graph, node)
        print(f"节点 {node}: {coefficient}")

    avg_coefficient_undirected = average_clustering_coefficient(undirected_graph)
    print(
        "\n无向图的平均聚类系数",
        avg_coefficient_undirected,
    )

    print("\n")

    directed_graph = nx.DiGraph()
    directed_graph.add_edges_from(
        [(1, 2), (2, 3), (3, 1), (3, 2), (4, 2), (4, 3), (5, 1)]
    )

    print("有向图的聚类系数")
    for node in directed_graph.nodes():
        coefficient = clustering_coefficient_directed(directed_graph, node)
        print(f"Node {node}: {coefficient}")

    avg_coefficient_directed = average_clustering_coefficient(
        directed_graph, is_directed=True
    )
    print("\n有向图的平均聚类系数", avg_coefficient_directed)

    plt.figure(figsize=(12, 6))

    plt.subplot(1, 2, 1)
    nx.draw(
        undirected_graph, with_labels=True, font_weight="bold", node_color="skyblue"
    )
    plt.title("Undirected Graph")

    plt.subplot(1, 2, 2)
    nx.draw(
        directed_graph,
        with_labels=True,
        font_weight="bold",
        node_color="lightcoral",
        arrowsize=20,
    )
    plt.title("Directed Graph")

    plt.show()


if __name__ == "__main__":
    main()

# 无向图的聚集系数：
# 节点 1: 0.6666666666666666
# 节点 2: 1.3333333333333333
# 节点 3: 1.3333333333333333
# 节点 4: 0.6666666666666666
# 节点 5: 0.0

# 无向图的平均聚类系数 0.7999999999999999

# 有向图的聚类系数
# Node 1: 0
# Node 2: 0
# Node 3: 0.5
# Node 4: 1.0
# Node 5: 0

# 有向图的平均聚类系数 0.3
