#!/bin/bash

#---------------------------------------------- Récupération des valeurs d'option

while test $# -gt 0; do
	case "$1" in
		-id)
			shift
			identity=$1
			shift
		;;

		-cov)
			shift
			coverage=$1
			shift
		;;
		
		-eval)
			shift
			evalue=$1
			shift
		;;

		--nostart)
			starting='FALSE'
			break ###################################" si --nostart n'est pas mis en dernier, on break et on n'a pas les paramètres...
		;;

		*)
			echo "$1 is not a recognized flag!"
			break
		;;
	esac
done

#---------------------------------------------- Fonction pour faire l'alignement

make_blast() {
  echo -e "Pour l'identification des orthologues & des gènes du core génome, nous avons utilisé les fichiers de sortie de blast fournis"
  echo -e "Les fichiers sont téléchargeables à l'adresse suivante : blast_outputs.tar.gz https://transfert.u-psud.fr/d5upkb8"
  echo -e "Il faut les décompresser à la main. Nous avons néanmoins réalisé l'étape de téléchargement et d'alignement"
  echo -e "Ces étapes prennent beaucoup de temps, elles peuvent être évitées avec le flag --nostart pour démarrer l'analyse directement"
  
  #fichier contenant les multifastas de chaque gène
  tar -xzvf prot/prot.tar.gz
  
  # Téléchargement des outils blast locaux
  wget -O ncbi-blast-2.11.0+-x64-linux.tar.gz ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.11.0+-x64-linux.tar.gz
  tar -xzvf ncbi-blast-2.11.0+-x64-linux.tar.gz
  rm ncbi-blast-2.11.0+-x64-linux.tar.gz
  chmod +x ncbi-blast-2.11.0+/bin # droit d'utilisation sur toutes les fonctions

  # Création des 21 bases de données
  for A in prot/*.fa;do
    ./ncbi-blast-2.11.0+/bin/makeblastdb -in $A -dbtype prot -out $A
  done

  #------------------------------------------
  # Réalisation des 21*21 blasts
  #------------------------------------------
  
  mkdir -p blast_outputs # repertoire de sauvegarde des alignements
  clear
  echo RUNNING NOW THE ALIGNEMENT'\n\n'

  #blast de chaque gène contre chaque database
	#query : $A
	#database : $B
  for A in prot/*.fa;do
    for B in prot/*.fa;do
    output_name=$(basename $A ".fa")_$(basename $B ".fa").bl
    echo $output_name
    ./ncbi-blast-2.11.0+/bin/blastp -query $A -db $B -out blast_outputs/$output_name -max_target_seqs 1 -outfmt '7 qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps'
    done
  done
}

#---------------------------------------------- Alignement

if [ $starting = 'TRUE' ]
then
  make_blast # si --nostart, alors on ne fait pas l'alignement
fi

#---------------------------------------------- Analyse des données en 3 étapes

echo "\n \t -------------------------------------------------------"
echo "\t Première étape : Parsing des données et concaténation"
echo "\t ------------------------------------------------------- \n"

# Entrée : résultats d'alignement de tous les génomes deux à deux : 21 génomes donc 441 fichiers
# Sortie : table d'orthologues, chaque ligne correspond à une paire de gènes orthologues

cat blast_outputs/*.bl | grep "^[^#;]" | cut -f 1,2,3,4,12 > "reciprocity/best_hits_list.txt"









echo "\n \t -------------------------------------------------------"
echo "\t Deuxième étape : Détermination des best hits réciproques"
echo "\t ------------------------------------------------------- \n"

# supairFinder ne conserve que les bests hits et filtre certaines query dont certain attributs sont inférieurs à un certain seuils
# Entrée : sortie du précédent
# Sortie : liste des best hits réciproques



python3 supairFinder.py -i "reciprocity/best_hits_list.txt" -o "reciprocity/reciprocity_list.txt" --seuil_identite ${identity} --seuil_coverage ${coverage} --seuil_evalue ${evalue}










echo "\n \t -----------------------------------------------------------"
echo "\t Troisième étape : Recherche de cliques"
echo "\t -----------------------------------------------------------\n"

# cliqueSearch pour la recherche de cliques max pour ainsi trouver le nombre d'éléments du core génome
# Entrée : sortie du précédent
# Sortie : liste des cliques contenant les gènes de la clique. Chaque clique est un élément du core génome et elle contient 21 gènes (pour 21 génomes).
# Il faut installer networkx sur Python3 : python3 -m pip install networkx



python3 cliqueSearch.py -i "reciprocity/reciprocity_list.txt" 21 -o "cliques/cliques.txt" "cliques/cliques_max.txt"


core_genome_size=$(cat cliques/cliques_max.txt | wc -l)
echo "Le nombre de cliques maximales et donc d'éléments dans le core génome est de : "${core_genome_size}"."
