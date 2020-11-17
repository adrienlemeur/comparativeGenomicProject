#!/bin/bash
# Script bash pour la boucle principale

#------------------------------------------
# Récupération et organisation des données
#------------------------------------------

starting='TRUE'
#le flag --nostart : permet de passer outre l'étape de téléchargement des documents / créations des bases de données / blast locaux

#si le premier argument est --nostart, n'importe pas les documents
while [ ! $# -eq 0 ];do
	case "$1" in
		--nostart)
			starting='FALSE'
			;;
	esac
	shift
done

echo -e "Pour l'identification des orthologues & des gènes du core génome, nous avons utilisé les fichiers de sortie de blast fournis"
echo -e "Les fichiers sont téléchargeables à l'adresse suivante : blast_outputs.tar.gz https://transfert.u-psud.fr/d5upkb8"
echo -e "Il faut les décompresser à la main."
echo -e "Nous avons néanmoins réalisé l'étape de téléchargement et d'alignement"
echo -e "Ces étapes prennent beaucoup de temps, elles peuvent être évitées avec le flag --nostart pour démarrer l'analyse directement"

if [ $starting = 'TRUE' ];then

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
fi

echo -e "\n \t ------------------------------------------"
echo -e "\t Première étape : Parsing des données et concaténation"
echo -e "\t ------------------------------------------ \n"
b=0 # on en aura besoin pour la comparaison des tailles de fichier avec 0

# Entrée : résultats d'alignement de tous les génomes deux à deux : 21 génomes donc 441 fichiers
mkdir -p reciprocity # Répertoire avec tous les résultats
cat blast_outputs/*.bl | grep "^[^#;]" | cut -f 1,2,3,4,12 > "reciprocity/best_hits_list.txt"

nbligne= sudo cat reciprocity/best_hits_list.txt | wc -l
if [ "$nbligne" > "$b" ];then
    echo "cat done"
else
    echo "Il y a eu un problème lors de la concaténation. Le fichier ortholog_results.txt est vide ou n'existe pas."
fi
# Sortie : table d'orthologue, chaque ligne correspond à une paire de gènes orthologues

echo -e "\n \t ------------------------------------------"
echo -e "\t Détermination des best hits réciproques"
echo -e "\t ------------------------------------------ \n"

#supairFinder ne conserve que les bests hits et filtre certaines query dont certain attributs sont inférieurs à un certain seuils
# Entrée : sortie du précédent
# Sortie : liste des best hits réciproques
python3 supairFinder.py -i "reciprocity/best_hits_list.txt" \
			-o reciprocity/reciprocity_list.txt \
			--seuil_identite 60 \
			--seuil_coverage 70 \
			--seuil_evalue 10^-10

nbligne= sudo cat reciprocity/reciprocity_list.txt | wc -l
if [ "$nbligne" > "$b" ];then
    echo "ortholog search done"
else
    echo "Il y a eu un problème lors de la détermination des best hits réciproques. Le fichier reciprocity_list.txt est vide ou n'existe pas."
fi

echo -e "\n \t ------------------------------------------"
echo -e "\t Troisième étape : Détermination des best hits réciproques"
echo -e "\t ------------------------------------------ \n"

mkdir -p cliques # Répertoire de sortie de cliqueSearch

#cliqueSearch pour la recherche de cliques max pour ainsi trouver le nombre d'éléments du core génome
# Entrée : sortie du précédent
# Sortie : liste des cliques contenant les gènes de la clique. Chaque clique est un élément du core génome et elle contient 21 gènes (pour 21 génomes).
# python et pas python3 car networkx n'est pas dans python3
python cliqueSearch.py -i "reciprocity/reciprocity_list.txt" -o "cliques/cliques_max.txt" "cliques/cliques_pas_max.txt"

nbligne= sudo cat cliques/cliques_max.txt | wc -l
if [ "$nbligne" > "$b" ];then
    echo "clique search done"
else
    echo "Il y a eu un problème lors de la détermination des cliques. Le fichier cliques_max.txt est vide ou n'existe pas."
fi



