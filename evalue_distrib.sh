#!/bin/sh

#---------------------------------------------- Récupération des données

starting='TRUE'
#flag --nostart : allows to skip the step of downloading documents
#no execution of installation.sh
case "$1" in
	--nostart)
		starting='FALSE'
		;;
esac

if [ $starting = 'TRUE' ];then
  #Creating a directory for the downloaded outputs
  mkdir -p Blast_outputs
  wget -O Blast_yeasts.tar.gz transfert.u-psud.fr/nq01n/download
  tar -xvf Blast_yeasts.tar.gz -C Blast_outputs/
fi

#---------------------------------------------- Parser

mkdir -p output_igorf
mkdir -p output_cds

parsing() {
  
}

if ! [ -s best_hits_list.txt ];then # si la sortie n'existe pas, on fait le parsing
  parsing
  echo "C'est bon"
fi

for file in `ls Blast_outputs/`;do
	cat blast_outputs/$file | grep "^[^#;]" | cut -f 1,2,3,4,12 > "temp.txt"
	
	# Output names with file basename
	genomeA_genomeB=$(basename $file .bl)
	output_igorf=$genomeA_genomeB"_orf.txt"
	output_cds=$genomeA_genomeB"_cds.txt"
	
	# Picking best hits and sorting them in igorf-igorf or cds-cds files
	python3 parseur_evalue.py -i $temp.txt -o output_igorf/$output_igorf output_cds/$output_cds
done

echo "C'est re bon"




#---------------------------------------------- Récupération des premières lignes

<<COMMENT
for file in `ls Blast_outputs/`;do
	# Output names with file basename
	genomeA_genomeB=$(basename $file .bl)
	output_igorf=$genomeA_genomeB"_orf.txt"
	output_cds=$genomeA_genomeB"_cds.txt"
	
	# Picking best hits and sorting them in igorf-igorf or cds-cds files
	python3 parser.py -i Blast_outputs/$file -o output_igorf/$output_igorf output_cds/$output_cds
done
>>

