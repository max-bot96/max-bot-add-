"""
MAX BOT - Render.com Entry Point
Runs Flask Dashboard ONLY (no Discord bot on Render)
"""
import sys, os

PORT = int(os.environ.get('PORT', 5000))

from app import app

if __name__ == "__main__":
    print(f"[RENDER] Dashboard on port {PORT}", flush=True)
    app.run(host='0.0.0.0', port=PORT, debug=False, threaded=True)

def create_app():
    return app
