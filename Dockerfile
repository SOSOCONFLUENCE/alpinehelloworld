#Grab the latest alpine image
FROM alpine:latest

# Install python and pip
RUN apk add --no-cache --update python3 py3-pip bash

# Créer un environnement virtuel
RUN python3 -m venv /venv

# Activer l'environnement virtuel et installer les dépendances
RUN /venv/bin/pip install --no-cache-dir -q -r /tmp/requirements.txt

# Utiliser l'environnement virtuel pour exécuter ton app
ENV PATH="/venv/bin:$PATH"

ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Expose is NOT supported by Heroku
# EXPOSE 5000 		

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku			
CMD gunicorn --bind 0.0.0.0:$PORT wsgi 

