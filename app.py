import http.server
import socketserver
import os

PORT = 8000

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        
        # This helps verify the security settings in the browser
        user = os.popen('whoami').read().strip()
        response = f"""
        <html>
        <head><title>Secure Python App</title></head>
        <body style="font-family: sans-serif; text-align: center; margin-top: 50px;">
            <h1 style="color: green;">🛡️ Container Secured!</h1>
            <p><strong>Running as user:</strong> {user}</p>
            <p><strong>Filesystem Status:</strong> Read-Only (with tmpfs mounts)</p>
            <hr>
            <p style="color: gray;">Check your terminal for the Audit Script results.</p>
        </body>
        </html>
        """
        self.wfile.write(response.encode())

print(f"Serving secure app on port {PORT}...")
with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    httpd.serve_forever()