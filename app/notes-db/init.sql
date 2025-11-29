-- Création de la table notes avec ID auto-incrémenté
CREATE TABLE IF NOT EXISTS notes (
    id SERIAL PRIMARY KEY,
    note TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertion de données de test (optionnel)
INSERT INTO notes (note) VALUES 
    ('Première note de test'),
    ('Deuxième note de test');