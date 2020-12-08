# Projet de Génomique Comparée
Groupe 10 : Leila OUTEMZABET, Adrien LE MEUR, Audrey ONFROY

Lien vers le Git principal : https://github.com/annelopes/Comparative_Genomics_AMI2B/tree/main/core_genome_Ecoli

### Répertoires secondaires
- prot : contient les génomes de Escherichia et Shigella pour faire les alignements (script dans TP1/main_TP1.sh)
- levure : idem pour les 6 levures, mais il n'y a pas le script pour faire l'alignement dans TP2...
- archives : anciens tests

## TP1 : Détection du core génome chez Escherichia et Shigella (bactéries)
- récupération des génomes et construction des 21 bases et 441 alignements **OU** récupération des 441 alignements déjà faits
- sauvegarde des best hits sous critères de couverture, identité et e-value
- confrontation des best hits pour déterminer les best hists réciproques
- idenfication du core génome parmi les BHR

#### Exécution rapide
Il faut renseigner les paramètres :
- -d permet de ne pas réaliser l'alignement. /!\ Avoir 441 alignements dans un répertoire **blast_outputs/**
- -i : pourcentage d'identité (ex : 70)
- -c : pourcentage de couverture (ex : 60)
- -e : seuil de e-value (ex : 10e-200)
```
$ sh main_TP1.sh -d -i 70 -c 60 -e 10e-200
```

## TP2 : Densité des e-values des bests hits selon qu'ils soient IGORF-IGORF ou CDS-CDS dans Saccharomyces (levures)
- récupération des 6x6 = 36 alignements des génomes de levures
- sauvegarde des bests hits sans critère
- répartition des bests hits IGORF ou CDS dans deux dossiers de sortie
- graphiques avec R (manuel)

#### Exécution rapide
Il faut renseigner les paramètres :
- --nostart permet de ne pas réaliser télécharger les fichiers. /!\ Avoir 36 alignements dans un répertoire **blast_outputs/**
```
$ sh main_TP2.sh (--nostart)
```

