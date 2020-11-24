import networkx as nx #import de la librairie networkx pour l'utilisation de la fonction find_cliques()
import sys,os


#Input
try :
	filename = sys.argv[sys.argv.index("-i")+1] #permet de recuperer le fichier de sortie generer apres l'application de la fonction de reciprocite
	#Il y aura dans les fichiers uniquement les genes des genomes dont l'homolgie est reciproque
	nb_genomes = sys.argv[sys.argv.index("-i")+2]#nombre de genomes
except :
	sys.exit()


try: #fichier de sortie pour stocker les resultats
	outputname = sys.argv[sys.argv.index("-o")+1]#pour stocker toutes les cliques
	outputname2 = sys.argv[sys.argv.index("-o")+2]#pour stocker les cliques max  
	
except :
	outputname = "cliques.txt"
	outputname2 = "cliques_max.txt"

#Fichier de sortie
os.system("rm -f "+outputname)
os.system("rm -f "+outputname2)

fclique = open(outputname, 'w') 
fcliquemax =open(outputname2, 'w') 

G = nx.read_edgelist(filename,delimiter='	') # les genes stockes dans le fichier d'entree sont des couples de genes homologues
#Chaque couple correspond a une arete d'un graphe
#La fonction read_edgelist va donc permettre de lire la liste des aretes pour permettre a la fonction qui suit de trouver les cliques maximales
for clq in nx.clique.find_cliques(G): #la fonction find_cliques permet de renvoyer toutes les cliques maximales dans un graphe non oriente G
	fclique.write(str(len(clq)))#stocker la longueur des cliques
	fclique.write("\t")	
	#for clq_item in clq:
		#fclique.write(clq_item.decode("utf-8"))
	fclique.write(str(clq)) # str added here
	fclique.write("\t")
	fclique.write("\n")	
fclique.close()

fclique = open(outputname, 'r') 
lines = fclique.readlines()
for line in lines :
	values = line.split("\t")
	if (values[0] == str(nb_genomes)) :
		fcliquemax.write(str(line))
fcliquemax.close()

