# Projet de Génomique Comparée
Lien vers le Git principal : https://github.com/annelopes/Comparative_Genomics_AMI2B/tree/main/core_genome_Ecoli

## Boucle principale (bash)
- récupération des génomes et construction des 21 bases et 441 alignements OU récupération des 441 alignements déjà faits
- sauvegarde des best hits sous critères
- confrontation des best hits pour déterminer les best hists réciproques (BHR)
- idenfication du core génome parmi les BHR

## Première étape : parsing (bash)
- parseur → récupérer les best hits et seuiller pour éliminer ceux qui sont insuffisants

## Deuxième étape : réciprocité (Python ou R)
- reciprocité → liste des orthologues, deux idées possibles :

1) *SUPAIR_FINDER.py*
2) Alternative : *reciprocity.R* : Utilisation de dplyr dans R pour faire une jointure, puis comparaison des valeurs pour chaque ligne

## Troisième étape : Identification du core génome (Python)
- identification → recherche de clique

### Choses à faire
- définir les critères parmi "qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps" pour savoir comment on détermine les orthologues
