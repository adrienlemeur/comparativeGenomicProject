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
  cat blast_outputs/*.bl | grep "^[^#;]" | cut -f 1,2,3,4,12 > "best_hits_list.txt"
}

deja='TRUE' # on n'a pas fait tourner la fonction parsing
if ! [ -s best_hits_list.txt ];then # si la sortie n'existe pas, on fait le parsing
  parsing
  deja='FALSE'
fi

#---------------------------------------------- Récupération des premières lignes

for file in `ls Blast_outputs/`;do
	# Output names with file basename
	genomeA_genomeB=$(basename $file .bl)
	output_igorf=$genomeA_genomeB"_orf.txt"
	output_cds=$genomeA_genomeB"_cds.txt"
	
	# Picking best hits and sorting them in igorf-igorf or cds-cds files
	python3 parser.py -i Blast_outputs/$file -o output_igorf/$output_igorf output_cds/$output_cds
done


