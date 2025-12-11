# Grab the latest alpine image
FROM alpine:latest

# Install python, pip and bash
RUN apk add --no-cache --update python3 py3-pip bash

# Ajouter le fichier requirements.txt avant de tenter l'installation
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Créer un environnement virtuel
RUN python3 -m venv /venv

# Activer l'environnement virtuel et installer les dépendances
RUN /venv/bin/pip install --no-cache-dir -q -r /tmp/requirements.txt

# Utiliser l'environnement virtuel pour exécuter l'app
ENV PATH="/venv/bin:$PATH"

# Définir une valeur par défaut pour le port (optionnel)
ENV PORT=5000

# Ajouter le code de l'application dans l'image Docker
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Créer un utilisateur non-root et l'utiliser pour exécuter l'app
RUN adduser -D myuser
USER myuser

# Lancer l'application avec Gunicorn
CMD gunicorn --bind 0.0.0.0:$PORT app:app
