#!/bin/bash

echo "Bienvenue dans le script d'installation de Docker pour Debian !"

# Mettre à jour le système
echo "Mise à jour du système..."
apt-get update
apt-get upgrade -y
echo "Mise à jour terminée."

# Installer les dépendances nécessaires
echo "Installation des dépendances nécessaires..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
echo "Dépendances installées."

# Ajouter la clé GPG officielle de Docker
echo "Ajout de la clé GPG officielle de Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "Clé GPG ajoutée."

# Ajouter le dépôt Docker APT
echo "Ajout du dépôt Docker APT..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Dépôt Docker APT ajouté."

# Mettre à jour l'index des paquets APT
echo "Mise à jour de l'index des paquets APT..."
apt-get update
echo "Index des paquets APT mis à jour."

# Installer Docker Engine
echo "Installation de Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io
echo "Docker Engine installé avec succès."

# Vérifier l'installation de Docker
echo "Vérification de l'installation de Docker en exécutant 'hello-world'..."
docker run hello-world
echo "Docker est installé et fonctionne correctement."

echo "Installation terminée !"