import logging as log
import mimetypes
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from socket import socket
from socketserver import BaseServer
from typing import Any


class Serv(BaseHTTPRequestHandler):
    def __init__(
        self,
        request: socket | tuple[bytes, socket],
        client_address: Any,
        server: BaseServer,
        root: Path,
    ) -> None:
        self.server_root = root
        super().__init__(request, client_address, server)

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
            if mode == "rb":
                with open(full_path, mode) as file:
                    self.wfile.write(file.read())
            else:
                with open(full_path, mode, encoding="utf-8") as file:
                    self.wfile.write(bytes(file.read(), "utf-8"))
        except FileNotFoundError:
            self.send_error(404, "File Not Found")
        except IsADirectoryError:
            self.send_error(403, "Directory Listing Not Allowed")
        except Exception as e:
            log.error(f"{full_path=}")
            self.send_error(500, str(e))


def serve(root: Path | None = None):
    root = root or Path(__file__).resolve().parent
    log.info(f"http server start with root: {root.resolve()}")
    httpd = HTTPServer(
        ("localhost", 8090), lambda *args, **kwargs: Serv(*args, **kwargs, root=root)
    )
    print("please open http://localhost:8090/index.html in your browser")
    httpd.serve_forever()
