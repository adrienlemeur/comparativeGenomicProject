#!/usr/bin/env python3
'''
    File name: super_pair_finder.py
    Author: Adrien Le Meur
    Date created: 0-/10/2020
    Date last modified: 06/10/2020
    Python Version: 3.0
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

with open(genomic_table) as gt:
	lines = gt.readlines()

dict_1 = {}
dict_2 = {}

for i in lines:
	i = i.strip().split("\t")

	dict_1[i[0]] = i[1]
	dict_2[i[1]] = i[0]

del lines

print("Le pire est derrière moi")

os.system("rm "+outputname)

with open(outputname, 'a') as po:
	for j in dict_1:
		if dict_1[j] in dict_2:
			if j == dict_2[dict_1[j]]:
				po.write(j+"\t"+dict_1[j]+"\n")
