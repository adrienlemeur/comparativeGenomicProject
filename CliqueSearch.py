#!/usr/bin/env python3

import networkx as nx #import de la librairie networkx pour l'utilisation de la fonction find_cliques()
import sys

#Input
try :
	filename = sys.argv[1] #permet de recuperer le fichier de sortie generer apres l'application de la fonction de reciprocite
	#Il y aura dans les fichiers uniquement les genes des genomes dont l'homolgie est reciproque
except :
	sys.exit()

f = open("output.txt", 'w')#fichier de sortie pour stocker les resultats

G = nx.read_edgelist(filename,delimiter='	') # les genes stockes dans le fichier d'entree sont des couples de genes homologues
#Chaque couple correspond a une arete d'un graphe
#La fonction read_edgelist va donc permettre de lire la liste des aretes pour permettre a la fonction qui suit de trouver les cliques maximales

for clq in nx.clique.find_cliques(G): #la fonction find_cliques permet de renvoyer toutes les cliques maximales dans un graphe non oriente G
	f.write(str(clq)) #noter la clique trouvee dans le fichier de sortie, en prenant garde de caster le resultat en string
	f.write("\n")
	
f.close()
