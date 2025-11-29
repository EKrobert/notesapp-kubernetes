# notes-frontend/Dockerfile
FROM nginx:alpine

# Copier le fichier HTML
COPY index.html /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
