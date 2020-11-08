
#!/usr/bin/env Rscript

## Chargement de dplyr et stringr
# dplyr : manipulation des tableaux de données
# stringr : manipulation des chaînes de caractères
installed = installed.packages()
installed = installed[,1] 
if (!is.element("dplyr", installed)){
  install.packages("dplyr")
}
if (!is.element("stringr", installed)){
  install.packages("stringr")
}
library(dplyr)
library(stringr)

## Contexte : On considère A et B deux génomes
# Le génome A a été aligné sur le génome B
# A l'étape précédente, on a récupéré les bests hits dans le B pour les gènes de A
# Les bests hits ont été filtré et seuls les meilleurs ont été retenus
# Ils sont donnés en entrée dans ce code
# Code bash : ./reciprocity A_to_B.txt B_to_A.txt

## Récupération des données depuis bash
A_to_B_file = commandArgs(TRUE)[1] # chaînes de caractères correspondant au nom du tableau des best hits de A dans B
B_to_A_file = commandArgs(TRUE)[2] # chaînes de caractères correspondant au nom du tableau des best hits de B dans A
A_to_B = read.table(A_to_B_file, header = TRUE) # premier ficher : best hits de A sur B
colnames(A_to_B) = c("colA", "colB1")
B_to_A = read.table(B_to_A, header = TRUE) # second fichier : best hits de B sur A
colnames(B_to_A) = c("colB2", "colA")

## Réalisation d'u,e jointure des deux fichiers par la colonne correspondant à A
# https://dplyr.tidyverse.org/reference/join.html
A_B = full_join(A_to_B, B_to_A, by = colA)
# full_join :
# return all rows and all columns from both x and y.
# Where there are not matching values, returns NA for the one missing

## Suppression les best hits non réciproques
# B.gene_b1  A.gene_a  B.gene_b1    -> reciprocal
# B.gene_b1  A.gene_a  B.gene_b2    -> to remove
# B.gene_b1  A.gene_a  NA           -> to remove
# Dans A_B, on filtre (conserve) les lignes telles que les colonnes B1 et B2 soient égales
A_B = filter(A_B, colB1 == colB2 & !is.na(colB1))
A_B = A_B %>% select(colA, colB1) # on conserve ces deux colonnes

## Extraction des noms des génomes
path = strsplit(commandArgs(TRUE)[1], "-vs-")[[1]] # les noms des fichiers d'entrée étaient A-vs-B.txt et B-vs-A.txt
# titre[1] correspond au nom du génome A et titre[2] correspond au nom du génome B.txt
path = paste("./reciprocity/", titre[1], "_", titre[2], sep = "") # nom de sortie : A_B.txt
nom_A = titre[1]
nom_B = strsplit(titre[2], ".txt")[[1]][1] # séparation du nom du génome B et du .txt, conservation du nom du génome B

## Enregistrement de la table sans faire de modification supplémentaire
colnames(A_B) = c("colA", "colB")
write.table(A_B, path, sep="\t") # enregistrement de la table en .txt dans le dossier reciprocity, avec le nom A_B.txt

## Renommage des contenus par anticipation de l'étape suivante (core génome)
A_B$colA = paste(nom_A,A_B$colA,sep=".")
A_B$colA = paste(nom_B,A_B$colB,sep=".")

## Affichage dans bash
cat(A_B) # sauvegarder via > A_B.txt

## Le résultat doit avoir la forme de :
# genomeA.gene1 genomeB.gene1
# genomeA.gene3 genomeB.gene7
# genomeA.gene4 genomeB.gene2
# genomeA.gene5 genomeB.gene5
