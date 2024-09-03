#!/bin/bash

echo "Bienvenue dans le script d'installation de Docker pour Debian !"

# Demander si l'utilisateur souhaite ajouter un swap et de quelle taille
echo "Souhaitez-vous ajouter un swap ? (Entrez non, 1, 2, 6, 8, 12 pour choisir la taille en Go)"
read -p "Veuillez entrer votre choix (par défaut : non) : " swap_choice

# Définir "non" comme valeur par défaut si l'utilisateur n'a rien saisi
swap_choice=${swap_choice:-non}

if [ "$swap_choice" != "non" ]; then
  echo "Configuration d'un swap de ${swap_choice}G..."
  
  # Désactiver le swap existant (s'il y en a un)
  dphys-swapfile swapoff
  
  # Modifier la taille du swap
  sed -i "s/^CONF_SWAPSIZE=.*$/CONF_SWAPSIZE=${swap_choice}/" /etc/dphys-swapfile
  
  # Réactiver le swap avec la nouvelle taille
  dphys-swapfile setup
  dphys-swapfile swapon
  
  echo "Swap de ${swap_choice}G configuré avec succès."
else
  echo "Aucun swap supplémentaire ne sera configuré."
fi

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