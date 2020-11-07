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

dict = {}

os.system("rm "+outputname)
with open(outputname, 'a') as po:
	for i in lines:
		i = i.strip().split("\t")

		if i[1] in dict:
			if i[0] == dict[i[1]]:
				po.write(i[0]+"\t"+i[1]+"\t"+dict[i[1]]+"\n")

		dict[i[0]] = i[1]

# A -> A1
# B -> B1
# C -> C1
# D -> D1
# E -> A1
# A1 -> A
