#!/usr/bin/env python3

#__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT
import sys, os, re

try:
	alignment = sys.argv[sys.argv.index("-i")+1]
	output_igorf = sys.argv[sys.argv.index("-o")+1]
	output_cds = sys.argv[sys.argv.index("-o")+2]
  
except :
	sys.exit()


#__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN

#import du fichier
with open(alignment) as ag:
	lines = ag.readlines()

# Fichier de sortie
os.system("rm -f "+output_igorf)
os.system("rm -f "+output_cds)

with open(outputname, 'a') as po:
	for i in lines:
		i = i.split("\t")
				
		genomeB = i[1].split("_")[0] # Eco4
		genomeA_gene_genomeB = i[0] + "_" + genomeB 
		
		if genomeA_gene_genomeB not in dict :
			dict[genomeA_gene_genomeB] = [i[0], i[1], float(i[2]), float(i[3]), -float(i[4])]
			
			genomeA = i[0].split("_")[0] # Eco1
			genomeB_gene_genomeA = i[1] + "_" + genomeA # Eco4_yyy_Eco1
			
			if genomeB_gene_genomeA in dict:
				if dict[genomeB_gene_genomeA][0] == dict[genomeA_gene_genomeB][1]:
					membre1 = dict[genomeA_gene_genomeB][2:4+1]
					membre2 = dict[genomeB_gene_genomeA][2:4+1]

					if(sum([(membre1[i] > seuils[i]) & (membre2[i] > seuils[i]) for i in range(0,3)]) == 3):
						po.write(i[0]+"\t"+i[1]+"\n")
