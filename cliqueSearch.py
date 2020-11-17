import networkx as nx #import de la librairie networkx pour l'utilisation de la fonction find_cliques()
import sys,os

#Input
try :
	filename = sys.argv[sys.argv.index("-i")+1] #permet de recuperer le fichier de sortie generer apres l'application de la fonction de reciprocite
	#Il y aura dans les fichiers uniquement les genes des genomes dont l'homolgie est reciproque
except :
	sys.exit()
	
try: #fichier de sortie pour stocker les resultats
	outputname = sys.argv[sys.argv.index("-o")+1]
	outputname2 = sys.argv[sys.argv.index("-o")+2]
	
except :
	outputname = "cliques_max.txt"
	outputname2 = "cliques_pas_max.txt"

#Fichier de sortie
os.system("rm -f "+outputname)
os.system("rm -f "+outputname2)

f = open(outputname, 'w') 
f2 =open(outputname2, 'w')

G = nx.read_edgelist(filename,delimiter='	') # les genes stockes dans le fichier d'entree sont des couples de genes homologues
#Chaque couple correspond a une arete d'un graphe
#La fonction read_edgelist va donc permettre de lire la liste des aretes pour permettre a la fonction qui suit de trouver les cliques maximales

nx.clique.find_cliques(G)
for clq in nx.clique.find_cliques(G): #la fonction find_cliques permet de renvoyer toutes les cliques maximales dans un graphe non oriente G
	if len(clq) < 21: #si la clique ne fait pas intervenir tous les genomes, on les stocke dans un fichier a part (cliques_pas_max)
		for clq_item in clq:
			f2.write(clq_item.decode("utf-8"))#pour encoder en utf8
			f2.write("\t")
		f2.write("\n")
	elif len(clq) == 21: #cliques faisant intervenir tous les genomes
		for clq_item in clq:
			f.write(clq_item.decode("utf-8"))
			f.write("\t")
		f.write("\n")

f.close()
f2.close()

