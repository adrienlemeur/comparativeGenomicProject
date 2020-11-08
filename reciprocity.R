
#!/usr/bin/env Rscript

## Chargement de dplyr
installed = installed.packages()
installed = installed[,1] 
if (!is.element("dplyr", installed)){
  install.packages("dplyr")
}
library(dplyr)

## On considère A et B deux génomes
# Le génome A a été aligné sur le génome B
# A l'étape précédente, on a récupéré les bests hits dans le B pour les gènes de A
# Les bests hits ont été filtré et seuls les meilleurs ont été retenus
# Ils sont donnés en entrée dans ce code
# Code bash : ./reciprocity A_to_B.txt B_to_A.txt

A_to_B_file = commandArgs(TRUE)[1] # chaînes de caractères
B_to_A_file = commandArgs(TRUE)[2] # chaînes de caractères
A_to_B = read.table(A_to_B_file, header = TRUE) # premier ficher : best hits de A sur B
colnames(A_to_B) = c("colA", "colB1")
B_to_A = read.table(B_to_A, header = TRUE) # second fichier : best hits de B sur A
colnames(B_to_A) = c("colB2", "colA")

## On réalise une jointure des deux fichiers par la colonne correspondant à A
# https://dplyr.tidyverse.org/reference/join.html

A_B = full_join(A_to_B, B_to_A, by = colA)
# return all rows and all columns from both x and y.
# Where there are not matching values, returns NA for the one missing

## On supprime les best hits non réciproques
# B.gene_b1  A.gene_a  B.gene_b1    -> reciprocal
# B.gene_b1  A.gene_a  B.gene_b2    -> to remove
# B.gene_b1  A.gene_a  NA           -> to remove
# Dans A_B, on filtre (conserve) les lignes telles que les colonnes B1 et B2 soient égales
A_B = filter(A_B, colB1 == colB2 & !is.na(colB1))

## Renommage et enregistrement
titre = strsplit(commandArgs(TRUE)[1], "-vs-")[[1]] # les noms des fichiers d'entrée étaient A-vs-B.txt et B-vs-A.txt
titre = paste("./reciprocity/", titre[1], "_", titre[2], sep ="") # nom de sortie : A_B.txt
write.table(A_B, titre, sep="\t") # enregistrement de la table en .txt
cat(A_B) # resultat dans bash

