import os, sys, socketserver, http.server
os.chdir(r"C:\Users\USER\Desktop\z1-pro")

class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def do_GET(self):
        path = self.path.split("?")[0]
        if path == "/" or path == "":
            path = "/terms.html"
        file_path = os.path.join(os.getcwd(), path.lstrip("/"))
        if not os.path.exists(file_path) or not file_path.endswith(".html"):
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"404 Not Found")
            return
        with open(file_path, "rb") as f:
            content = f.read()
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(content)))
        self.send_header("Connection", "close")
        self.end_headers()
        self.wfile.write(content)

with socketserver.TCPServer(("0.0.0.0", 8080), H) as httpd:
    httpd.serve_forever()
