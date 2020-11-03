# On récupère les 21*21 alignements


# Parseur :
# Entrée : 1 alignement de A vers B
# Sortie : pour chaque gène de A, le best hit dans B, s'il existe
# Critère : parmi qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps

def parseur(entree):
  sortie = entree
  
  return(sortie)

# Réciprocité
# Entrée : best hits de A vers B et best hits de B vers A
# Sortie : couple réciproque
# Moyen : on considère un graphe orienté et on cherche les sommets (u,v) tels qu'il existe une arete de u vers v et une de v vers u

def reciprocite(AversB, BversA):
  sortie = TRUE
  
  return(sortie)

# Core genome
# Entrée : liste des gènes "réciproques" pour le couple A-B, pour A-B parmi les 27 génomes
# Sortie : liste des gènes communs pour tous les A-B
# Moyen : recherche de clique

def core_genome(liste de taille 21):
  sortie = TRUE
  
  return(sortie)
