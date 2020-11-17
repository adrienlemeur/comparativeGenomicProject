#!/usr/bin/env python3
'''
    File name: supairFinder.py
    Author: Adrien Le Meur et éventuellement les autres membres :D
    Date created: 06/10/2020
    Date last modified: 08/10/2020
    Python Version: 3.6
'''

#__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT
import sys, os

try:
	genomic_table = sys.argv[sys.argv.index("-i")+1]
	seuil_id = int(sys.argv[sys.argv.index("--seuil_identite")+1])
	seuil_cov = int(sys.argv[sys.argv.index("--seuil_coverage")+1])
	seuil_eval = int(sys.argv[sys.argv.index("--seuil_evalue")+1])
except :
	sys.exit()

try:
	outputname = sys.argv[sys.argv.index("-o")+1]
except :
	outputname = "putative_orthologues.txt"

seuils = [seuil_id, seuil_cov, -seuil_eval] # on met un - pour que toutes les comparaisons soient des >


#__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN

#import du fichier
with open(genomic_table) as gt:
	lines = gt.readlines()

dict = {}

#Fichier de sortie
os.system("rm -f "+outputname)

with open(outputname, 'a') as po:
	for i in lines:
		i = i.split("	")
		
		# dict[i[0]][0].split("_")[0]       genome du best it de i[0]
		# i[1].split("_")                   genome de i[1]
		# Soit on ajoute i[0] dans le dictionnaire parce qu'il n'y est pas
		# Soit i[0] est dans le dictionnaire mais le genome sur lequel il est aligné n'a pas été déjà comparé à lui, on ajoute la ligne
		
		# On veut le best hits de Eco1_1 dans les 21 génomes
		# Eco1_2 Eco4_yyy
		# Eco1_1 Eco1_1
		# Eco1_1 Eco1_2
		# Eco1_1 Eco1_3
		# Eco1_1 Eco2_xxx
		# Eco1_1 Eco3_xxx
		# Eco1_1 Eco4_xxx
				
		genomeB = i[1].split("_")[0]
		genomeA_gene_genomeB = i[0] + genomeB		
		
		if genomeA_gene_genomeB not in dict :
		#if i[0] not in dict or ((i[0] in dict) and (dict[i[0]][0].split("_")[0] != i[1].split("_")[0])):
			# permet de sélectionner la première ligne de chaque query (best hit)
			# Chaque clef correspond à une query, chaque valeur correspond à un best-hit
			# Chaque ligne correspond à un tuple [query, best hit, identity, coverage, e-value]
			# Création d'une nouvelle entrée dans le dictionnaire, avec la query comme clef et les quatre autres données comme value
			genomeB = i[1].split("_")[0]
			genomeA_gene_genomeB = i[0] + genomeB
			dict[genomeA_gene_genomeB] = [i[0], i[1], float(i[2]), float(i[3]), -float(i[11])]

			# Si i[1] est une clef du dictionnaire (c'est à dire qu'on a déjà rencontré notre best-hit avant)
			if i[1] in dict:
				# Si la valeur du best-hit de notre best hit est égal à celle de notre query, les deux gènes sont réciproques
				if i[0] == dict[i[1]][0] : # and (i[0] != i[1]):
					# vérification des seuils du couple
					membre1 = dict[i[1]][1:3] # liste avec le % d'identite, la couverture et - la e-value
					membre2 = dict[i[0]][1:3]
					# on teste tous les seuils : membrex > seuils est une liste de trois booléens
					# pour que les trois seuils soient validés, il faut que la comparaison donne TRUE
					if (membre1 > seuils) and (membre2 > seuils) :
						#on écrit le couple de gènes query / best-hit à la suite de notre doc résultat
						po.write(i[0]+"\t"+i[1]+"\n")
						
