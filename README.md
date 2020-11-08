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
2) *SUPAIR_FINDER.py* : 
- CAT de toutes les tables de best hits
- Premier passage → toutes la première colonne (gène query) en clef de dictionnaire et la deuxième colonne (best hit) en valeurs
- On parcours toute la colonne 2, pour chaque valeur on regarde si la value associée à la clef est la même que la colonne 1 (si elle existe)
  → parcours 3 fois la grande table
  → est-ce que c'est mieux que la méthode d'Audrey ? REPONSE : C'est une alternative :)

## Quatrième étape : Identification du core génome (Python)
- Méthode : Recherche de clique

### Choses à faire
- rédiger le plan
- faire la structure de données pour faire la boucle de tout ça
- écrire le parseur
- définir les critères parmi "qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps" pour savoir comment on détermine les orthologues
