import mimetypes
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path


class Serv(BaseHTTPRequestHandler):
    # 设置根目录为当前脚本所在目录
    server_root = Path(__file__).resolve().parent

    def do_GET(self):
        # 如果访问的是根路径，则重定向到 index.html
        if self.path == "/":
            self.path = "/index.html"

        # 构建完整的文件路径
        full_path = (self.server_root / self.path.lstrip("/")).resolve()

        # 检查请求的路径是否在服务的根目录内，防止路径遍历攻击
        if not full_path.is_relative_to(self.server_root):
            self.send_error(403, "Forbidden")
            return

        try:
            # 获取文件的 MIME 类型
            mime_type, _ = mimetypes.guess_type(full_path)
            if mime_type is None:
                # 默认为文本类型
                mime_type = "text/plain"

            # 设置 Content-Type 响应头
            self.send_response(200)
            self.send_header("Content-type", mime_type)
            self.end_headers()

            # 根据 MIME 类型选择合适的模式打开文件
            mode = "rb" if "image" in mime_type or "application" in mime_type else "r"
            with open(full_path, mode) as file:
                if mode == "rb":
                    self.wfile.write(file.read())
                else:
                    self.wfile.write(bytes(file.read(), "utf-8"))
        except FileNotFoundError:
            self.send_error(404, "File Not Found")
        except IsADirectoryError:
            self.send_error(403, "Directory Listing Not Allowed")
        except Exception as e:
            self.send_error(500, str(e))


def serve():
    httpd = HTTPServer(("localhost", 8090), Serv)
    print("please open http://localhost:8090/index.html in your browser")
    httpd.serve_forever()
