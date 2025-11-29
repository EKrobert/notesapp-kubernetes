
## NotesApp – Déploiement Automatisé sur Kubernetes (Minikube)
Application web 3-tiers complète (Frontend + API Flask + PostgreSQL)

## 📋 Description

Projet de déploiement automatisé d'une application web 3-tiers sur Kubernetes (Minikube) utilisant Ansible et Terraform.

**URL finale →** `http://notes.<MINIKUBE_IP>.nip.io`  

## Fonctionnalités
- Liste, Ajout, affichage et suppression de notes en temps réel
- Données persistantes (PVC + `init.sql`)
- Une seule URL publique grâce à **Ingress NGINX + nip.io**
- Déploiement entièrement automatisé



## Fonctionnalités
- Ajout, affichage et suppression de notes en temps réel
- Données persistantes (PVC + `init.sql`)
- Une seule URL publique grâce à **Ingress NGINX + nip.io**
- Déploiement entièrement automatisé

## Structure du projet
```
notesapp-project/
├── ansible/
│   ├── inventory.ini
│   └── site.yml                  # Playbook principal (tout-en-un)
├── app/
│   ├── notes-api/                # Flask + Dockerfile
│   ├── notes-db/
│   │   └── init.sql              # Création automatique de la table notes
│   └── notes-frontend/           # HTML/JS + Dockerfile
├── terraform/
│   ├── main.tf
│   ├── namespace.tf
│   ├── database.tf               # PostgreSQL + PVC + ConfigMap
│   ├── api.tf
│   ├── frontend.tf
│   └── ingress.tf                # Ingress avec rewrite-target (fonctionnel)
├── docker-compose.yml            # Bonus : test ultra-rapide en local
├── nginx.conf                    # Pour docker-compose
└── README.md                     # Ce fichier
```

## Déploiement automatique (5 à 10 minutes)

Depuis WSL (Ubuntu), à la racine du projet :

```bash
ansible-playbook ansible/site.yml --ask-become-pass
```

Le playbook fait **TOUT** :
1. Installe Docker, Minikube, kubectl, Terraform
2. Démarre Minikube (driver docker)
3. Installe l’Ingress Controller NGINX
4. Construit les images dans Minikube
5. Applique toute l’infrastructure Terraform
6. Affiche l’URL finale

Quand c’est terminé ouvrez un **nouveau terminal** et lancez :

minikube tunnel    # Laisse ouvert


Puis ouvrez votre navigateur Windows :

**http://notes.<IP_AFFICHEE>.nip.io**  
(Exemple : http://notes.192.168.49.2.nip.io)


## Test rapide en local

```bash
docker compose up --build
# → http://localhost
```
