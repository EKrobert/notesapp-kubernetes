from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
import os
import time

app = Flask(__name__)
CORS(app)

def get_conn():
    """Connexion PostgreSQL avec retry pour Docker"""
    retries = 5
    while retries > 0:
        try:
            return psycopg2.connect(
                host=os.getenv("DB_HOST", "notes-db"),
                database=os.getenv("DB_NAME", "notes"),
                user=os.getenv("DB_USER", "postgres"),
                password=os.getenv("DB_PASSWORD", "password")
            )
        except psycopg2.OperationalError:
            retries -= 1
            print(f"Attente de la DB... {retries} tentatives restantes")
            time.sleep(2)
    raise Exception("Impossible de se connecter à la base de données")


@app.route('/notes', methods=['GET'])
def notes():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT id, note FROM notes ORDER BY id")
    rows = [{"id": row[0], "note": row[1]} for row in cur.fetchall()]
    cur.close()
    conn.close()
    return jsonify(rows)


@app.route('/add', methods=['POST'])
def add():
    note = request.json['note']
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("INSERT INTO notes (note) VALUES (%s)", (note,))
    conn.commit()
    cur.close()
    conn.close()
    return "OK"


@app.route('/delete/<int:note_id>', methods=['DELETE'])
def delete(note_id):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("DELETE FROM notes WHERE id = %s", (note_id,))
    conn.commit()
    affected = cur.rowcount
    cur.close()
    conn.close()
    
    if affected > 0:
        return "OK"
    else:
        return "Not Found", 404


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)