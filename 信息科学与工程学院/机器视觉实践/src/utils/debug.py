import csv


def csv_diff(file1, file2):
    with open(file1, "r") as f1, open(file2, "r") as f2:
        reader1 = csv.reader(f1)
        reader2 = csv.reader(f2)

        for row_index, (row1, row2) in enumerate(zip(reader1, reader2)):
            for col_index, (cell1, cell2) in enumerate(zip(row1, row2)):
                if cell1 != cell2:
                    print(
                        f"Difference at (row: {row_index + 1}, col: {col_index + 1}): '{cell1}' != '{cell2}'"
                    )


if __name__ == "__main__":
    csv_diff("add.txt", "get.txt")
