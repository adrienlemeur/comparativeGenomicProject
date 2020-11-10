#!/usr/bin/env python3

import sys,re

#Input
try :
	output_file = sys.argv[1]
except :
	sys.exit()

#Function
def parser(output_file) :
	"""
	input : nom du fichier output d'un blast
	output : retourne un dictionnaire qui a pour cle le nom d'une query-id
	aim : 
	"""
	i = 0
	genome_dict = {}
	with open(output_file, "r") as f:
		lines = f.readlines()
		regex = re.compile("^# \d.")
		for line in lines :
			if regex.match(line) : #pour trouver la derniere ligne avec un commentaire #
				line_interest = lines[i+1] #on recupere la ligne qui nous interesse, celle qui suit la derniere ligne en commentaire
				values = line_interest.split()#on recupere les valeurs des differents champs
				query_id = values[0]
				genome_dict[query_id]=[] #on cree une liste associee a chaque query id (n'a pas encore d'interet)
				genome_dict[query_id].append(values[1])#on recupere que la subject id pour l'instant et pas le reste des valeurs (donc liste pas necessaire)
			i+=1	
		return genome_dict
		
#Main        
dico = parser(output_file)
#print dico
