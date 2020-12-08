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

print(alignment)
print(output_igorf)
print(output_cds)

with open(output_igorf, 'a') as igorf:
	with open(output_cds, 'a') as cds:
		for line_interest in lines:
			values = line_interest.split("\t")

			print(line_interest)

			query_id = str(values[0])
			subject_id = str(values[1])
			A = str(values[2])
			B = str(values[3])
			evalue = str(values[4])

			line_to_write = query_id+"\t"+subject_id+"\t"+A+"\t"+B+"\t"+evalue+"\n"
			if (len(query_id.split("_")) == 4 and len(subject_id.split("_")) == 4) :
				igorf.write(line_to_write)
			elif (len(query_id.split("_")) == 3 and len(subject_id.split("_")) == 3) :
				cds.write(line_to_write)
