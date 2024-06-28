import math

import networkx as nx

G = nx.Graph()
G.add_edges_from([(1, 2), (1, 3), (2, 4), (3, 4), (4, 5)])


def calculate_CN(G, node_x, node_y):
    neighbors_x = set(G.neighbors(node_x))
    neighbors_y = set(G.neighbors(node_y))
    common_neighbors = neighbors_x.intersection(neighbors_y)
    return len(common_neighbors)


def calculate_AA(G, node_x, node_y):
    neighbors_x = set(G.neighbors(node_x))
    neighbors_y = set(G.neighbors(node_y))
    common_neighbors = neighbors_x.intersection(neighbors_y)

    aa_score = 0
    for common_neighbor in common_neighbors:
        aa_score += 1 / math.log(len(list(G.neighbors(common_neighbor))))

    return aa_score


def calculate_RA(G, node_x, node_y):
    neighbors_x = set(G.neighbors(node_x))
    neighbors_y = set(G.neighbors(node_y))
    common_neighbors = neighbors_x.intersection(neighbors_y)

    ra_score = 0
    for common_neighbor in common_neighbors:
        ra_score += 1 / len(list(G.neighbors(common_neighbor)))

    return ra_score


node_x = 1
node_y = 4

cn_score = calculate_CN(G, node_x, node_y)
aa_score = calculate_AA(G, node_x, node_y)
ra_score = calculate_RA(G, node_x, node_y)

print(f"CN Score between {node_x} and {node_y}: {cn_score}")
print(f"AA Score between {node_x} and {node_y}: {aa_score}")
print(f"RA Score between {node_x} and {node_y}: {ra_score}")

# CN Score between 1 and 4: 2
# AA Score between 1 and 4: 2.8853900817779268
# RA Score between 1 and 4: 1.0
