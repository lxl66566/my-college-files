from collections import defaultdict


class Graph:
    def __init__(self):
        self.graph = defaultdict(list)

    def add_edge(self, u, v):
        self.graph[u].append(v)
        self.graph[v].append(u)

    def dfs(self, node, visited, connected_component):
        visited[node] = True
        connected_component.append(node)
        for neighbor in self.graph[node]:
            if not visited[neighbor]:
                self.dfs(neighbor, visited, connected_component)

    def find_connected_components(self):
        visited = {node: False for node in self.graph}
        all_connected_components = []

        for node in self.graph:
            if not visited[node]:
                connected_component = []
                self.dfs(node, visited, connected_component)
                all_connected_components.append(connected_component)

        return all_connected_components


social_network = Graph()
social_network.add_edge(1, 2)
social_network.add_edge(2, 3)
social_network.add_edge(4, 5)

connected_components = social_network.find_connected_components()

if len(connected_components) == 1:
    print("是全连通图")
else:
    print("不是全连通图")
    print("子图：")
    for component in connected_components:
        print(component)

# 不是全连通图
# 子图：
# [1, 2, 3]
# [4, 5]
