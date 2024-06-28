s = [
    "COW",
    "DOG",
    "SEA",
    "RUG",
    "ROW",
    "MOB",
    "BOX",
    "TAB",
    "BAR",
    "EAR",
    "TAR",
    "DIG",
    "BIG",
    "TEA",
    "NOW",
    "FOX",
]


def p():
    for i in s:
        for j in i:
            print("[{}],".format(j), end="")
        print()


s = sorted(s, key=lambda x: x[-1])
p()
s = sorted(s, key=lambda x: x[-2])
p()
s = sorted(s, key=lambda x: x[-3])
p()
