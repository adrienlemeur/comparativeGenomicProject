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
# ATTENTION NE MARCHE PLUS (LA VERSION DE BLAST A ETE MODIFIEE), J'AI REFAIT L'IMPORT DES FICHIERS POUR QUE TOUT SOIT AUTOMATIQUE 
# CA NE CHANGE RIEN, MAIS NE PERDEZ PAS DE TEMPS A RECODER CA, CEST FAIT -> JE PUSH DEMAIN MATIN 
# ADRIEN
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

#------------------------------------------
# Réalisation des 21*21 alignements
#------------------------------------------

clear
echo RUNNING NOW THE ALIGNEMENT'\n\n'

for A in prot/*.fa
do
	for B in prot/*.fa
	do
	output_name=$(basename $A ".fa")_$(basename $B ".fa").bl
	echo $output_name
	############# Audrey : on peut faire un alignement du génome sur lui-même, pas besoin du if ?
	############# Adrien : ça prend + de temps et ça apporte pas d'information (on veut trouver des ortologues entre les génomes, pas à l'intérieur)
	############# Audrey : mais il peut y avoir des orthologues au sein du même génome ?
	#############          Genre dans A, genex et geney sont orthologues, puis dans B : geneb best hit de genex et dans C,
	#############          genec best hist de geney ? Je ne sais pas si c'est possible...
	
	if [  $A != $B ]
		then
			./ncbi-blast-2.10.1+/bin/blastp -query $A -db $B -out Blast_output/$output_name -max_target_seqs 1 -outfmt '7 qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps'
		fi
	done
done

# Fin de cette partie : 21x21 fichiers txt
# On peut directement récupérer les fichiers créées par Anne Lopes :
wget -O blast_outputs.tar.gz https://transfert.u-psud.fr/d5upkb8
gunzip blast_outputs.tar.gz # on dézippe
tar -xvf blast_outputs.tar # on dé-tar

#------------------------------------------
# Traitement des données
#------------------------------------------

# Première étape : détermination des best hits pour chaque fichier dans blast_outputs
# Fait, -max_target_seq 1 permet de ne garder que le meilleur hit


# Deuxième étape : détermination des best hits réciproques

#Autre solution pour la méthode d'Audrey avec R et le merge
for bl in Blast_output/*.bl
do
	grep "^[^#;]" $bl > $(basename $bl ".bl").txt
done



# Création du répertoire des sorties de réciprocité, si ce n'est pas déjà fait
if [ ! -f reciprocity ]
then
 	mkdir -p reciprocity
	#mkdir -p suffit, j'ai pas eu d'erreur sans le if
fi

for A in prot/*.fa
do
	for B in prot/*.fa
	do
		# récupération des noms de base
		nomA=$(basename $A)
		nomB=$(basename $A)
		
		# reconstruction des noms de fichiers contenant les best hits
		file1=$nomA-vs-$nomB.txt # .txt des best hits de A sur B
		file2=$nomB-vs-$nomA.txt # .txt des best hits de B sur A
		
		# détermination des réciproques et l'enregistrement du fichier de sortie se fait tout seul
		# nom de sortie : genomeA_genomeB.txt
		# pour l'explication de la syntaxe : https://github.com/IARCbioinfo/R-tricks
		./reciprocity.R file1 file2 >> A_B.txt #pour qu'il concatène
done

#solution alternative pour la réciprocité :
#grep "^[^#;]" Blast_output/*.bl > metagenomic_table.txt
#python3 SUPAIR_FINDER.py -i metagenomic_table.txt

#ressort un fichier texte où chaque ligne correspond à une paire d'orthologue séparés par une tabulation
#note : supprime les autres infos mais ça peut s'arranger facilement
#re-note : tous les génomes sont concaténés


# Troisième étape : détermination du core génome





#------------------------------------------
# Résultats
#------------------------------------------
