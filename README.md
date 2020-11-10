# Projet de Génomique Comparée
Groupe 10 : Leila OUTEMZABET, Adrien LE MEUR, Audrey ONFROY
Lien vers le Git principal : https://github.com/annelopes/Comparative_Genomics_AMI2B/tree/main/core_genome_Ecoli

## Boucle principale (main.sh)
- récupération des génomes et construction des 21 bases et 441 alignements OU récupération des 441 alignements déjà faits
- sauvegarde des best hits sous critères
 → (A FAIRE) définir les critères parmi "qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps" pour savoir quels candidats d'orthologues on conserve
- confrontation des best hits pour déterminer les best hists réciproques (BHR)
- idenfication du core génome parmi les BHR

## Première étape : parsing (supairFinder.py)
Objectif : récupérer les best hits et seuiller pour éliminer ceux qui sont insuffisants

Entrée : alignement du génome A sur le génome B et de B sur A

Sortie (intermédiaire) : première ligne de chaque résultat (meilleur e-value)


## Deuxième étape : réciprocité (supairFinder.py)
Objectif : liste des orthologues

Entrée (intermédiaire) : paires de best hits

Sortie : liste des best hits réciproques


Deux idées possibles pour la réciprocité :
1) *SUPAIR_FINDER.py*
2) Alternative : *reciprocity.R* : Utilisation de dplyr dans R pour faire une jointure, puis comparaison des valeurs pour chaque ligne

## Troisième étape : Identification du core génome (cliqueSearch.py)
Objectif : identifier le core génome

Méthode : recherche de clique

Entrée : liste bets hits réciproques pour tous les 110 binômes de génome

Sortie : liste des génome.gène dans chaque clique
