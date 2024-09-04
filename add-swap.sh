#!/bin/bash

# Demander à l'utilisateur s'il souhaite ajouter un swap et de choisir la taille
read -p "Souhaitez-vous ajouter un swap ? (Entrez non, 1, 2, 6, 8, 12 pour choisir la taille en Go) [non] : " swap_size

# Si l'utilisateur n'entre rien, utiliser "non" par défaut
swap_size=${swap_size:-non}

# Vérification de la réponse
if [ "$swap_size" == "non" ]; then
    echo "Aucun swap n'a été ajouté."
    exit 0
elif [[ "$swap_size" =~ ^(1|2|6|8|12)$ ]]; then
    swapfile="/swapfile"

    # Créer un fichier swap de la taille demandée
    fallocate -l ${swap_size}G $swapfile

    # S'assurer que le fichier a les bonnes permissions
    chmod 600 $swapfile

    # Configurer le fichier en tant qu'espace swap
    mkswap $swapfile

    # Activer le swap
    swapon $swapfile

    # Ajouter le swap au fichier /etc/fstab pour qu'il soit activé au démarrage
    echo "$swapfile none swap sw 0 0" | tee -a /etc/fstab

    echo "Un swap de ${swap_size}G a été ajouté et activé."
else
    echo "Option invalide. Veuillez entrer 'non', 1, 2, 6, 8 ou 12."
    exit 1
fi