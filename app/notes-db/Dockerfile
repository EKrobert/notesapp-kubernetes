# notes-db/Dockerfile
FROM postgres:13-alpine
ENV POSTGRES_DB=notes
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
COPY init.sql /docker-entrypoint-initdb.d/
EXPOSE 5432