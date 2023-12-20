import networkx as nx


def calculate_betweenness_centrality(graph):
    node_betweenness = nx.betweenness_centrality(
        graph, normalized=True, endpoints=False
    )

    edge_betweenness = nx.edge_betweenness_centrality(graph, normalized=True)

    return node_betweenness, edge_betweenness


def main():
    G = nx.Graph()
    G.add_edges_from([(1, 2), (1, 3), (2, 3), (2, 4), (3, 4), (4, 5)])

    node_betweenness, edge_betweenness = calculate_betweenness_centrality(G)

    print("节点介数：")
    for node, value in node_betweenness.items():
        print(f"Node {node}: {value}")

    print("\n边介数：")
    for edge, value in edge_betweenness.items():
        print(f"Edge {edge}: {value}")


if __name__ == "__main__":
    main()

# 节点介数：
# Node 1: 0.0
# Node 2: 0.16666666666666666
# Node 3: 0.16666666666666666
# Node 4: 0.5
# Node 5: 0.0

# 边介数：
# Edge (1, 2): 0.2
# Edge (1, 3): 0.2
# Edge (2, 3): 0.1
# Edge (2, 4): 0.30000000000000004
# Edge (3, 4): 0.30000000000000004
# Edge (4, 5): 0.4
