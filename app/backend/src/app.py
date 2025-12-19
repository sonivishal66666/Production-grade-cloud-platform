from flask import Flask, jsonify
from prometheus_client import DataCollectorRegistry, DispatcherMiddleware, prometheus_client
from werkzeug.serving import run_simple
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app

app = Flask(__name__)

# Basic Health Check
@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "backend"}), 200

@app.route('/api/data')
def get_data():
    return jsonify({"data": "This is data from the production backend!", "version": "1.0.0"}), 200

# Add prometheus wsgi middleware to route /metrics requests
app_dispatch = DispatcherMiddleware(app, {
    '/metrics': make_wsgi_app()
})

if __name__ == '__main__':
    # Run on 0.0.0.0:5000
    run_simple('0.0.0.0', 5000, app_dispatch)
