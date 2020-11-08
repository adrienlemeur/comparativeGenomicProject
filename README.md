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
- Maintenant optimisé (!) : Parcours une seule fois la table et identifie les couples de réciproques grâce à un système révolutionnaire de pointeurs (détails dans le code), 1 million de lignes traitées en quelque secondes ! SUPAIR FINDER, l'essayer c'est l'adopter !

(second degré) Suggestion de battle : On met un time.time au début et à la fin des deux méthodes, on les fait tourner sur le même jeu de données, et on regarde le temps qu'elles prennent ! Si il y a un écart de moins de 5 % du meilleur temps entre les 2 méthodes, on dit qu'elles sont équivalentes et on les accepte toutes les deux. On pourra alors valider ou non le slogan du supair finder. La méthode dplyr est plus modeste, elle n'a pas de slogan x)

#### Benchmark
(team premier degré)

GO ! J'ai mis dans le dossier benchmark un script R qui génère trois jeux de donnée, deux pour toi et un pour moi 👀

la génération de dataset est seedée. Le \_dataset Adrien (13 milions de lignes) correspond aux deux autres concaténés et mélangés (2 * 750k lignes)

Toutes les lignes sont des orthologues (750k paires d'orthologues, chacune dans un fichier différent pour toi, tout mélangé pour moi)

Résultat SUPER_FINDER™ : 3s2

s'il y a moins de 5% de différence, on prend ma méthode qui n'utilise pas de library :p


## Quatrième étape : Identification du core génome (Python)
- Méthode : Recherche de clique

### Choses à faire
- rédiger le plan
- faire la structure de données pour faire la boucle de tout ça
- écrire le parseur
- définir les critères parmi "qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps" pour savoir comment on détermine les orthologues
