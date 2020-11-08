# Projet de Génomique Comparée
Lien vers le Git principal : https://github.com/annelopes/Comparative_Genomics_AMI2B/tree/main/core_genome_Ecoli

## Première étape : récupération des fichiers
- script bash

## Seconde étape : parsing (bash)
- parseur → récupérer les best hits et seuiller pour éliminer ceux qui sont insuffisants

## Troisième étape : réciprocité (R)
- reciprocité → liste des orthologues

#### Deux idées pour la réciprocité :
1) *reciprocity.R* : Utilisation de dplyr dans R pour faire une jointure, puis comparaison des valeurs pour chaque ligne
2) METHODE ALTERNATIVE : *SUPAIR_FINDER.py* (en commentaire avec la ligne bash pour le cat dans le main.sh) :
- Maintenant optimisé (!) : Parcours une seule fois la table et identifie les couples réciproque grâce à un système de "pointeurs" (détail dans le code), 1 million de lignes (avec juste les noms de gène) en quelque secondes / est-ce que c'est mieux que la méthode d'Audrey ? Je pense que oui

## Quatrième étape : Identification du core génome (Python)
- Méthode : Recherche de clique

### Choses à faire
- rédiger le plan
- faire la structure de données pour faire la boucle de tout ça
- écrire le parseur
- définir les critères parmi "qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps" pour savoir comment on détermine les orthologues
