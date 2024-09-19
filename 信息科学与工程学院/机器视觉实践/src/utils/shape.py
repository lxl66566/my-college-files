from dataclasses import dataclass


@dataclass
class Point:
    x: float
    y: float

    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return Point(self.x - other.x, self.y - other.y)

    def __repr__(self):
        return f"({self.x}, {self.y})"

    def distance(self, other):
        return (self.x - other.x) ** 2 + (self.y - other.y) ** 2

    @property
    def tuple(self):
        return (self.x, self.y)

    @property
    def int_tuple(self):
        return (int(self.x), int(self.y))


@dataclass
class Rect:
    x: int
    y: int
    width: int
    height: int

    def get_vertex4(self):
        return [
            Point(self.x, self.y),
            Point(self.x + self.width, self.y),
            Point(self.x + self.width, self.y + self.height),
            Point(self.x, self.y + self.height),
        ]

    def get_vertex2(self):
        return [
            Point(self.x, self.y),
            Point(self.x + self.width, self.y + self.height),
        ]

    def __repr__(self):
        return f"(x={self.x}, y={self.y}, width={self.width}, height={self.height})"

    @property
    def tuple(self):
        return (self.x, self.y, self.width, self.height)


@dataclass
class Line:
    start: Point
    end: Point

    def __repr__(self) -> str:
        return f"(start={self.start}, end={self.end})"

    @property
    def tuple(self):
        return (*self.start.tuple, *self.end.tuple)


@dataclass
class Circle:
    center: Point
    radius: int

    def __repr__(self):
        return f"({self.center}, {self.radius})"
