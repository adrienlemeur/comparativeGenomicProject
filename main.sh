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

#Pour l'identification des orthologues & des gènes du core génome, nous avons utilisé les dossiers d'alignement fournis
#Nous avons néanmoins réalisé l'étape de téléchargement et d'alignement
#Ces étapes prennent beaucoup de temps, elles peuvent être zappées avec le flag --nostart pour démarrer l'analyse directement

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
	# Réalisation des 21*21 alignements
	#------------------------------------------

	clear
	echo RUNNING NOW THE ALIGNEMENT'\n\n'

	#blast de chaque gène contre chaque database
		#query : $A
		#database : $B
	for A in prot/*.fa;do
		for B in prot/*.fa;do
			output_name=$(basename $A ".fa")_$(basename $B ".fa").bl
			echo $output_name

			./ncbi-blast-2.11.0+/bin/blastp -query $A -db $B -out Blast_output/$output_name -max_target_seqs 1 -outfmt '7 qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps'
	done
done

exit

#------------------------------------------
# OU BIEN : Récupération des alignements déjà faits
#------------------------------------------

wget -O blast_outputs.tar.gz https://transfert.u-psud.fr/d5upkb8
tar -xzvf blast_outputs.tar # on dé-tar

#------------------------------------------
# Traitement des données
#------------------------------------------



# Première étape : détermination des best hits pour chaque fichier dans blast_outputs
# Deuxième étape : détermination des best hits réciproques
# => Les deux étapes sont faites par supairFinder.py

# Répertoire de sortie de réciprocité
mkdir -p reciprocity

for A in prot/*.fa;do
	for B in prot/*.fa;do

		nomA=$(basename $A ".fa"); nomB=$(basename $B ".fa");

		#reconstruction des noms de fichiers contenant les alignements (dans Blast_output)
		file1=$nomA"-vs-"$nomB".bl" # Recherche des gènes de A sur B
		file2=$nomB"-vs-"$nomA".bl" # Recherche des gènes de A sur B

		#grep : concatène les deux fichiers et ne garde que les lignes qui ne commencent pas par #
		grep "^[^#;]" Blast_output/$file1 Blast_output/$file2 > temp_table.txt

		#Fichier de sortie : Table d'orthologue, chaque ligne correspond à une paire de gènes orthologues

		#supairFinder ne conserve que les bests hits et filtre certaines query dont certain attributs sont inférieurs à un certain seuils
		python3 supairFinder.py -i temp_table.txt -o output.txt

	done
done
