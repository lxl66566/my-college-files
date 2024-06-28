from dataclasses import dataclass


@dataclass
class point:
    x: int
    y: int
    w: float

    def manhattan(self, other) -> int:
        return abs(self.x - other.x) + abs(self.y - other.y)


def calc(s: list[point]):
    s.sort(key=lambda x: point(0, 0, 0).manhattan(x))
    accu = 0
    index = 0
    while index < len(s):
        accu += s[index].w
        if accu >= 0.5:
            break
        index += 1

    print(s[index])


calc(
    [
        point(1, 1, 0.2),
        point(1, 2, 0.3),
        point(1, 3, 0.05),
        point(2, 4, 0.15),
        point(3, 5, 0.3),
    ]
)

# point(x=1, y=2, w=0.3)
