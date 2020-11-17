#!/bin/bash
# Script bash pour la boucle principale

#------------------------------------------
# Récupération et organisation des données
#------------------------------------------

starting='TRUE'

#le flag -- nostart : permet de passer outre l'étape de téléchargement des documents / créations des bases de données / blast locaux

#si le premier argument est --nostart, n'importe pas les documents
while [ ! $# -eq 0 ];do
	case "$1" in
		--nostart)
			starting='FALSE'
			;;
	esac
	shift
done

#########
#
#	Pour l'identification des orthologues & des gènes du core génome, nous avons utilisé les fichiers de sortie de blast fournis
#	Nous avons néanmoins réalisé l'étape de téléchargement et d'alignement
#	Ces étapes prennent beaucoup de temps, elles peuvent être évitées avec le flag --nostart pour démarrer l'analyse directement
#
#########
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

	mkdir -p blast_outputs

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



#------------------------------------------
# OU BIEN : Récupération des alignements déjà faits
#------------------------------------------

#Sorties de blasts fournies
# wget -O blast_outputs.tar.gz https://transfert.u-psud.fr/d5upkb8
# à extraire à la main.....
#	tar -xzvf blast_outputs.tar.gz


#------------------------------------------
# Traitement des données
#------------------------------------------

## Première étape : Parsing des données et concaténation
# Entrée : résultats d'alignement de tous les génomes deux à deux : 21 génomes donc 441 fichiers
mkdir -p reciprocity # Répertoire avec tous les résultats
cat blast_outputs/*.bl | grep "^[^#;]" | cut -f 1,2,3,4,12 > "reciprocity/best_hits_list.txt"

nbligne = cat cliques/best_hits_list.txt | wc -l
if [ $nbligne > 0 ];then
    echo "cat done"
else
    echo "Il y a eu un problème lors de la concaténation. Le fichier ortholog_results.txt est vide ou n'existe pas."
fi
# Sortie : table d'orthologue, chaque ligne correspond à une paire de gènes orthologues

## Deuxième étape : Détermination des best hits réciproques
#supairFinder ne conserve que les bests hits et filtre certaines query dont certain attributs sont inférieurs à un certain seuils
# Entrée : sortie du précédent
# Sortie : liste des best hits réciproques
python3 supairFinder.py -i "reciprocity/best_hits_list.txt" \
			-o reciprocity/reciprocity_list.txt \
			--seuil_identite 60 \
			--seuil_coverage 70 \
			--seuil_evalue 10^-10

nbligne = cat cliques/reciprocity_list.txt | wc -l
if [ $nbligne > 0 ];then
    echo "ortholog search done"
else
    echo "Il y a eu un problème lors de la détermination des best hits réciproques. Le fichier reciprocity_list.txt est vide ou n'existe pas."
fi

## Troisième étape : Détermination des best hits réciproques
mkdir -p cliques # Répertoire de sortie de cliqueSearch

#cliqueSearch pour la recherche de cliques max pour ainsi trouver le nombre d'éléments du core génome
# Entrée : sortie du précédent
# Sortie : liste des cliques contenant les gènes de la clique. Chaque clique est un élément du core génome et elle contient 21 gènes (pour 21 génomes).
python cliqueSearch.py -i "reciprocity/reciprocity_list.txt" -o cliques/cliques_max.txt cliques/cliques_pas_max.txt

nbligne = cat cliques/cliques_max.txt | wc -l
if [ $nbligne > 0 ];then
    echo "clique search done"
else
    echo "Il y a eu un problème lors de la détermination des cliques. Le fichier cliques_max.txt est vide ou n'existe pas."
fi



