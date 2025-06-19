import sys
from pathlib import Path

from PyPDF2 import PdfReader, PdfWriter


def insert_pdf(original_pdf_path, insert_pdf_path, output_pdf_path, insert_after_page):
    """
    将一个PDF插入到另一个PDF的指定页码之后

    参数:
        original_pdf_path: 原始PDF文件路径
        insert_pdf_path: 要插入的PDF文件路径
        output_pdf_path: 输出PDF文件路径
        insert_after_page: 插入到第几页之后(从0开始计数)
    """
    # 创建PDF读写对象
    original_pdf = PdfReader(original_pdf_path)
    insert_pdf = PdfReader(insert_pdf_path)
    output_pdf = PdfWriter()

    # 检查插入页码是否有效
    if insert_after_page < 0 or insert_after_page >= len(original_pdf.pages):
        raise ValueError(
            f"无效的插入页码 {insert_after_page}，文档共有 {len(original_pdf.pages)} 页"
        )

    # 添加原始PDF中插入位置之前的页面
    for i in range(insert_after_page + 1):
        output_pdf.add_page(original_pdf.pages[i])

    # 添加要插入的PDF的所有页面
    for page in insert_pdf.pages:
        output_pdf.add_page(page)

    # 添加原始PDF中剩余的页面
    for i in range(insert_after_page + 1, len(original_pdf.pages)):
        output_pdf.add_page(original_pdf.pages[i])

    # 写入输出文件
    with open(output_pdf_path, "wb") as f:
        output_pdf.write(f)


if __name__ == "__main__":
    filedir = Path(__file__).parent
    原始pdf = filedir / "sample.pdf"
    插入pdf = filedir / "任务书.pdf"
    输出pdf = filedir / "sample.pdf"
    插入页码 = 0

    try:
        insert_pdf(原始pdf, 插入pdf, 输出pdf, 插入页码)
        print(
            f"成功将 {插入pdf} 插入到 {原始pdf} 的第 {插入页码} 页之后，结果保存到 {输出pdf}"
        )
    except Exception as e:
        print(f"发生错误: {str(e)}")
        sys.exit(1)
