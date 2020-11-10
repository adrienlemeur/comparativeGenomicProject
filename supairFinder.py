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
except :
	sys.exit()

try:
	outputname = sys.argv[sys.argv.index("-o")+1]
except :
	outputname = "putative_orthologues.txt"


#__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN

#import du fichier
with open(genomic_table) as gt:
	lines = gt.readlines()

dict = {}
#si le fichier de sorti existe, le supprime ('a' permet de coller l'output à un fichier déjà existe et le crée s'il n'exite pas) 
os.system("rm "+outputname)
# a = append, écris à la suite
with open(outputname, 'a') as po:
	for i in lines:
		if(line[0] != "#"):
			i = i.strip().split("\t")
			#i[0] = nom du gène query / i[1] = nom du meilleur hit
			#Dictionnaire = table de hash
			#Deux éléments : une clef (unique) et une valeur associée (peut être n'importe quoi, même un dictionnaire)
			#Quand on entre la clef, on accède directement à la valeur associée (complexité moyenne : 1) au lieu de parcourir l'ensemble de la table !
			#Chaque clef correspond à une query, chaque valeur correspond à un best-hit
			# /!\ COMME LA CLEF D'UN DICTIONNAIRE EST UNIQUE, LA QUERY DOIT ÊTRE UNIQUE /!\
			#Chaque ligne correspond à un tuple [query, best hit]
			#Si i[1] est une clef du dictionnaire (c'est à dire qu'on a déjà rencontré notre best-hit avant)
			if i[1] in dict:
				#Alors on lit le best-hit de notre best-hit. Si la valeur est égale à celle de notre query, bingo ! C'est réciproque !
				if i[0] == dict[i[1]]:
					#on écrit le couple de gènes query / best-hit à la suite de notre doc résultat
					po.write(i[0]+"\t"+i[1]+"\n")
			#On créé une nouvelle entrée dans notre dictionnaire, avec la query comme clef et le best-hit comme value
			#sélectionne la première ligne
			if i[0] not in dict:
				dict[i[0]] = i[1]
			
# Petit exemple pour essayer de faire l'algo à la main, c'est plus simple pour comprendre
# A -> A1
# B -> B1
# C -> C1
# D -> D1
# E -> A1
# A1 -> A

#Je lis la dernière ligne. Si j'ai déjà rencontré A, je regarde le best-hit de A -> A1, la query de A -> réciproque

		#On pourrait faire des conditions pour essayer de grapiller 2 secondes mais le programme est asser opti comme ça imo
		#On pourrait aussi faire ça en C mais c'est (vraiment) trop compliqué et ça sert à rien
		#On pourrait aussi recompiler le python en C mais j'ai la flemme et pas sûr qu'on gagne grand chose
