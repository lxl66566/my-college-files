import matplotlib.pyplot as plt
import networkx as nx


def average_path_length(graph):
    total_length = 0
    total_paths = 0

    for node in graph:
        distances, paths = bfs(graph, node)
        total_length += sum(distances.values())
        total_paths += len(paths)

    average_length = total_length / total_paths
    return average_length


def bfs(graph, start):
    distances = {node: float("inf") for node in graph}
    paths = {node: [] for node in graph}

    queue = [start]
    distances[start] = 0

    while queue:
        current = queue.pop(0)
        for neighbor in graph[current]:
            if distances[neighbor] == float("inf"):
                distances[neighbor] = distances[current] + 1
                paths[neighbor] = paths[current] + [current]
                queue.append(neighbor)

    return distances, paths


def path_distribution(graph):
    all_paths = []

    for node in graph:
        _, paths = bfs(graph, node)
        all_paths.extend(paths.values())

    return all_paths


def average_path_length_weighted(graph):
    return nx.average_shortest_path_length(graph, weight="weight")


def weighted_path_distribution(graph):
    all_paths = []

    for node in graph:
        paths = nx.single_source_dijkstra_path(graph, node, weight="weight")
        all_paths.extend(paths.values())

    return all_paths


def main():
    unweighted_graph = {1: [2, 3], 2: [1, 3, 4], 3: [1, 2, 4], 4: [2, 3, 5], 5: [4]}

    print("Unweighted Graph:")
    print("Average Path Length (L):", average_path_length(unweighted_graph))
    print("Path Distribution:", path_distribution(unweighted_graph))
    print()

    weighted_graph = nx.Graph()
    weighted_graph.add_edge(1, 2, weight=2)
    weighted_graph.add_edge(2, 3, weight=1)
    weighted_graph.add_edge(3, 4, weight=3)
    weighted_graph.add_edge(4, 5, weight=2)

    print("Weighted Graph:")
    print("Average Path Length (L):", average_path_length_weighted(weighted_graph))
    print("Weighted Path Distribution:", weighted_path_distribution(weighted_graph))

    plt.figure(figsize=(10, 5))

    plt.subplot(1, 2, 1)
    nx.draw(nx.Graph(unweighted_graph), with_labels=True, font_weight="bold")
    plt.title("Unweighted Graph")

    plt.subplot(1, 2, 2)
    nx.draw(weighted_graph, with_labels=True, font_weight="bold")
    plt.title("Weighted Graph")

    plt.show()


if __name__ == "__main__":
    main()

# Unweighted Graph:
# Average Path Length (L): 1.2
# Path Distribution: [[], [1], [1], [1, 2], [1, 2, 4], [2], [], [2], [2], [2, 4], [3], [3], [], [3], [3, 4], [4, 2], [4], [4], [], [4], [5, 4, 2], [5, 4], [5, 4], [5], []]

# Weighted Graph:
# Average Path Length (L): 4.0
# Weighted Path Distribution: [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5], [2], [2, 1], [2, 3], [2, 3, 4], [2, 3, 4, 5], [3], [3, 2], [3, 4], [3, 2, 1], [3, 4, 5], [4], [4, 3], [4, 5], [4, 3, 2], [4, 3, 2, 1], [5], [5, 4], [5, 4, 3], [5, 4, 3, 2], [5, 4, 3, 2, 1]]
