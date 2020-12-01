#!/usr/bin/env python3



#__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT
import sys, os

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
		for line in lines :
			if regex.match(line) : #pour trouver la derniere ligne avec un commentaire #
				  line_interest = lines[i+1] #on recupere la ligne qui nous interesse, celle qui suit la derniere ligne en commentaire
				  values = line_interest.split()#on recupere les valeurs des differents champs
				  query_id = values[0].split("_")
				  subject_id = values[1].split("_")
				  evalue = values[10]
				  if (len(query_id)== 4 && len(subject_id) == 4) :
				    igorf.write(values[0]+"\t"+values[1]+"\t"+evalue+"\n")
				  elif (len(query_id)== 3 && len(subject_id) == 3) :
				    cds.write(values[0]+"\t"+values[1]+"\t"+evalue+"\n")
          
            
    
    
    

    
              
