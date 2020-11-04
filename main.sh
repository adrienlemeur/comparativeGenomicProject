#!/bin/bash
# Script bash pour la boucle principale

#------------------------------------------
# Récupération et organisation des données
#------------------------------------------



#le flag --nostart permet de ne pas retélécharger les fichiers à chaque fois
starting='TRUE'

while [ ! $# -eq 0 ]
do
	case "$1" in
		--nostart)
			starting='FALSE'
			;;
	esac
	shift
done

if [ $starting = 'TRUE' ]
then
	echo $starting

	# On se place dans le répertoire du projet qui contient uniquement prot.tar
	tar -xvf prot.tar # dézippage

	# Téléchargement de l'outil blast
	wget -O ncbi-blast-2.10.1+-x64-linux.tar.gz ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.10.1+-x64-linux.tar.gz
	gunzip ncbi-blast-2.10.1+-x64-linux.tar.gz # on dézippe
	tar -xvf ncbi-blast-2.10.1+-x64-linux.tar # on dé-tar
	rm ncbi-blast-2.10.1+-x64-linux.tar

	chmod +x ncbi-blast-2.10.1+/bin # droit d'utilisation sur toutes les fonctions


	# Création des 27 bases de données
	if [ ! -f Blast_db ]
	then
	  mkdir -p Blast_db
	fi

	for A in prot/*.fa
	do
		./ncbi-blast-2.10.1+/bin/makeblastdb -in $A -dbtype "prot" -out Blast_db/$(basename $A ".fa")
	done
fi


# Dossier de sortie des alignements
if [ ! -f Blast_output ];then
	mkdir -p Blast_output
fi

# Réalisation des 21*21 alignements
for A in prot/*.fa
do
	for B in Blast_db/*.pdb
	do
	# A est un fichier de type nom.fa
	# B est un fichier nom.pdb
	
	output_name= echo $(basename $A)_$(basename $B).txt

	echo $A
	echo $B
	
	./ncbi-blast-2.10.1+/bin/blastp -query $A -db $(basename $B) -out Blast_output/$output_name -outfmt '7 qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps'
	done
done

# Fin de cette partie : 21x21 fichiers txt

#------------------------------------------
# Traitement des données
#------------------------------------------









#------------------------------------------
# Résultats
#------------------------------------------
