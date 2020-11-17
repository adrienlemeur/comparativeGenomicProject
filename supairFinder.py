#!/usr/bin/env python3
'''
    File name: supairFinder.py
    Author: Adrien Le Meur
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
		if i[0] not in dict : #permet de sélectionner la première ligne de chaque query (best hit)
			#Chaque clef correspond à une query, chaque valeur correspond à un best-hit
			#Chaque ligne correspond à un tuple [query, best hit, identity, coverage, e-value]
			#Création d'une nouvelle entré dans le dictionnaire, avec la query comme clef et les quatre autres données comme value
			dict[i[0]] = [i[1], float(i[2]), float(i[3]), -float(i[11])]

			#Si i[1] est une clef du dictionnaire (c'est à dire qu'on a déjà rencontré notre best-hit avant)
			if i[1] in dict:
				#Si la valeur du best-hit de notre best hit est égal à celle de notre query, les deux gènes sont réciproques
				if (i[0] == dict[i[1]][0]) and (i[0] != dict[i[1]][1]):
					# vérification des seuils du couple
					membre1 = dict[i[1]][1:3] # liste avec le % d'identite, la couverture et - la e-value
					membre2 = dict[i[0]][1:3]
					# on teste tous les seuils : membrex > seuils est une liste de trois booléens
					# pour que les trois seuils soient validés, il faut que la comparaison donne TRUE
					if (membre1 > seuils) and (membre2 > seuils) :
						#on écrit le couple de gènes query / best-hit à la suite de notre doc résultat
						po.write(i[0]+"\t"+i[1]+"\n")
						
