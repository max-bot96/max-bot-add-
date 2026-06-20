"""
MAX BOT - Render.com Entry Point
Runs Flask Dashboard ONLY (no Discord bot on Render)
"""
import sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

PORT = int(os.environ.get('PORT', 5000))

if __name__ == "__main__":
    from app import app
    print(f"[RENDER] Dashboard on port {PORT}")
    app.run(host='0.0.0.0', port=PORT, debug=False, threaded=True)

def create_app():
    from app import app as flask_app
    return flask_app
