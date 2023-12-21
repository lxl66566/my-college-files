class point:
    def __init__(self, x, y, w):
        self.x = x
        self.y = y
        self.w = w

    def __str__(self):
        return "(x:{}, y:{}, w:{})".format(self.x, self.y, self.w)

    def __add__(self, other):
        return point(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return point(self.x - other.x, self.y - other.y)

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

# (x:1, y:2, w:0.3)
