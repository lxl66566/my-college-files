#!/bin/bash

# 遍历目录中的所有文件
find . -type f | while read file; do
    # 使用file命令检查文件类型
    if file --mime "$file" | grep -q text; then
        # 如果文件是文本文件，使用uchardet命令检测其编码
        ENCODING=$(uchardet "$file")
        # 使用iconv命令将其转换为UTF-8
        iconv -f "$ENCODING" -t UTF-8 "$file" -o "${file}.utf8"
        mv "${file}.utf8" "$file"
    fi
done