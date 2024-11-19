from pathlib import Path

import chardet


def detect_encoding(file_path: Path):
    with open(file_path, "rb") as f:
        raw_data = f.read()
    result = chardet.detect(raw_data)
    return result["encoding"]


def convert_to_utf8(file_path: Path):
    detected_encoding = detect_encoding(file_path)
    if detected_encoding is None:
        print(f"Could not detect encoding for file: {file_path}")
        return

    content = file_path.read_text(encoding=detected_encoding)
    _ = file_path.write_text(content, encoding="utf-8")
    print(f"Converted {file_path} from {detected_encoding} to UTF-8")


def convert_folder_to_utf8(folder_path: Path):
    for file_path in folder_path.glob("**/*"):
        if file_path.is_file():
            convert_to_utf8(file_path)


def move_prefix(folder_path: Path):
    for file_path in folder_path.glob("**/*"):
        if file_path.is_file():
            new_name = file_path.name.replace("task\\", "")
            new_path = file_path.with_name(new_name)
            print(f"Renaming {file_path} to {new_path}")
            _ = file_path.rename(new_path)


if __name__ == "__main__":
    move_prefix(Path(__file__).parent / "code")
    convert_folder_to_utf8(Path(__file__).parent / "code")
