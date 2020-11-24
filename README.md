# Projet de Génomique Comparée
Groupe 10 : Leila OUTEMZABET, Adrien LE MEUR, Audrey ONFROY

Lien vers le Git principal : https://github.com/annelopes/Comparative_Genomics_AMI2B/tree/main/core_genome_Ecoli

## Boucle principale (main.sh)
- récupération des génomes et construction des 21 bases et 441 alignements OU récupération des 441 alignements déjà faits
- sauvegarde des best hits sous critères de couverture, identité et e-value
- confrontation des best hits pour déterminer les best hists réciproques
- idenfication du core génome parmi les BHR

## Exécution rapide
Il faut renseigner les paramètres :
- --nostart permet de ne pas réaliser l'alignement. Il faut avoir 441 alignements dans un répertoire **blast_outputs/** /!\
- -id : pourcentage d'identité (ex : 70)
- -cov : pourcentage de couverture (ex : 60)
- -eval : seuil de e-value (ex : 10e-200)
```
$ sh main.sh --nostart -id 70 -cov 60 -eval 10e-200
```

## Première étape : suppression des commentaires (dans main.sh)
**Objectif** : supprimer les commentaires

**Entrée** : alignement du génome A sur le génome B et de B sur A

**Sortie** : suppression des lignes avec des commentaires et fusion des deux fichiers en une sortie A-against-B.bl.list

## Deuxième étape : réciprocité (supairFinder.py)
**Objectif** : déterminer les best hits

**Entrée** : liste A-against-B.bl.list

**Sortie** : liste des best hits réciproques

## Troisième étape : Identification du core génome (cliqueSearch.py)
**Objectif** : identifier le core génome

**Méthode** : recherche de clique

**Entrée** : liste bets hits réciproques pour tous les 110 binômes de génome

**Sortie** : liste des gènes dans chaque clique

**Post-traitement** : récupérer uniquement les cliques de taille 21, pour qu'elles représentent le core génome et pas le pan
