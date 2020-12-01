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

with open(output_igorf, 'a') as igorf : 
	with open (output_cds, 'a') as cds :
		regex = re.compile("^# \d.")
		for i in range(len(lines)-1) :
			line = lines[i]
			if regex.match(line) : #pour trouver la derniere ligne avec un commentaire #
				line_interest = lines[i+1] #on recupere la ligne qui nous interesse, celle qui suit la derniere ligne en commentaire
				values = line_interest.split()#on recupere les valeurs des differents champs
				
				print("___")
				print(line_interest)
				print(values)
				print(values[0], values[1], values[10])
				
				query_id = str(values[0])
				subject_id = str(values[1])
				evalue = str(values[10])
				
				line_to_write = query_id+"\t"+subject_id+"\t"+evalue+"\n"
				if (len(query_id.split("_")) == 4 and len(subject_id.split("_")) == 4) :
					igorf.write(line_to_write)
				elif (len(query_id.split("_")) == 3 and len(subject_id.split("_")) == 3) :
					cds.write(line_to_write)
         
