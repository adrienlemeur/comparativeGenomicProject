#!/bin/bash
# Script bash pour la boucle principale

#------------------------------------------
# Récupération et organisation des données
#------------------------------------------

#le flag --nostart permet de ne pas retélécharger les fichiers à chaque fois
starting='TRUE'

# on parcourt le dossier et si on rencontre un document, il n'y a plus besoin de faire le téléchargement, donc starting='FALSE'
while [ ! $# -eq 0 ]
do
	case "$1" in
		--nostart)
			starting='FALSE'
			;;
	esac
	shift
done

# s'il faut télécharger les données, on les télécharge et on crée les 21 bases de données (pour les 21 génomes)
if [ $starting = 'TRUE' ]
then

	# On se place dans le répertoire du projet qui contient uniquement prot.tar
	tar -xvf prot.tar # dézippage

	# Téléchargement de l'outil blast
	wget -O ncbi-blast-2.10.1+-x64-linux.tar.gz ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.10.1+-x64-linux.tar.gz
	gunzip ncbi-blast-2.10.1+-x64-linux.tar.gz # on dézippe
	tar -xvf ncbi-blast-2.10.1+-x64-linux.tar # on dé-tar
	rm ncbi-blast-2.10.1+-x64-linux.tar

	chmod +x ncbi-blast-2.10.1+/bin # droit d'utilisation sur toutes les fonctions
	
	# Création du répertoire des bases de données, si ce n'est pas déjà fait
	if [ ! -f Blast_db ]
	then
	  mkdir -p Blast_db
	fi
	
	# Création des 27 bases de données
	for A in prot/*.fa
	do
		./ncbi-blast-2.10.1+/bin/makeblastdb -in $A -dbtype prot -out $A
	done
fi

# Les sorties .txt de la boucle ci-dessous sont de la forme :
<<COMMENT
# BLASTP 2.10.1+
# Query: Eco4_1
# Database: Blast_db/Escherichia_coli_536
# Fields: query id, subject id, % identity, alignment length, mismatches, gap opens, q. start, s. start, s. end, evalue, bit score, query length, subject length, gaps
# 4 hits found
Eco4_1	Eco1_1244	25.714	35	26	0	25	68	102	3.0	25.4	169	418	0
Eco4_1	Eco1_4087	26.829	41	23	1	25	259	292	3.8	25.0	169	477	7
Eco4_1	Eco1_775	27.273	99	54	2	70	84	165	7.2	23.9	169	410	18
Eco4_1	Eco1_4557	32.143	28	19	0	101	9	36	9.9	22.3	169	64	0
# BLAST processed 1 queries
COMMENT


# Dossier de sortie des alignements
if [ ! -f Blast_output ]
then
	mkdir -p Blast_output
fi

# Réalisation des 21*21 alignements
for A in prot/*.fa
do
	for B in prot/*.fa
	do
	
	output_name=$(basename $A ".fa")_$(basename $B ".fa").bl
	echo $output_name
	if [  $A != $B ]
		then
			./ncbi-blast-2.10.1+/bin/blastp -query $A -db $B -out Blast_output/$output_name -max_target_seqs 1 -outfmt '7 qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps'
		fi
	done
done
exit
# Fin de cette partie : 21x21 fichiers txt
# On peut directement récupérer les fichiers créées par Anne Lopes :$
wget -O blast_outputs.tar.gz https://transfert.u-psud.fr/d5upkb8
gunzip blast_outputs.tar.gz # on dézippe
tar -xvf blast_outputs.tar # on dé-tar

#------------------------------------------
# Traitement des données
#------------------------------------------

# Première étape : détermination des bests hits pour chaque fichier dans blast_outputs





# Seconde étape : détermination du core génome





#------------------------------------------
# Résultats
#------------------------------------------
