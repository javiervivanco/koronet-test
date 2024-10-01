from flask import Flask, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
import redis
import os

app = Flask(__name__)

# Configure PostgreSQL
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'postgresql://user:password@0.0.0.0/koronet_db')
db = SQLAlchemy(app)

# Configure Redis
redis_client = redis.Redis(
    host=os.getenv('REDIS_HOST', 'redis'),
    port=int(os.getenv('REDIS_PORT', 6379)),
    db=0
)

class Visit(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    count = db.Column(db.Integer, default=0)

@app.route('/')
def hello_html():
    # Increment visit count in PostgreSQL
    visit = Visit.query.first()
    if not visit:
        visit = Visit(count=0)
        db.session.add(visit)
    else:
        visit.count += 1
    db.session.commit()

    # Increment visit count in Redis
    redis_client.incr('visits')

    return render_template('index.html',
                           postgres_visits=visit.count,
                           redis_visits=int(redis_client.get('visits') or 0))

@app.route('/visits')
def get_visits():
    visit = Visit.query.first()
    postgres_visits = visit.count if visit else 0
    redis_visits = int(redis_client.get('visits') or 0)

    return jsonify({
        "postgres_visits": postgres_visits,
        "redis_visits": redis_visits
    })

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        app.run(host='0.0.0.0', port=5000)