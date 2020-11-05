# Projet de Génomique Comparée
Lien vers le Git principal : https://github.com/annelopes/Comparative_Genomics_AMI2B/tree/main/core_genome_Ecoli

# Première étape : récupération des fichiers
Script bash

# Seconde étape : parsing (bash)
- parseur -> récupérer les best hits et seuiller pour éliminer ceux qui dont insuffisants

# Troisième étape : réciprocité (R)
- reciprocité -> liste des orthologues

# Troisième étape : Identification du core génome (Python)
- Méthode : Recherche de clique


# Choses à faire
- rédiger le plan
- faire la structure de données pour faire la boucle de tout ça
- écrire le parseur
- définir les critères parmi "qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps" pour savoir comment on détermine les orthologues
