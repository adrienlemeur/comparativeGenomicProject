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

for file in `ls Blast_outputs/`;do
	echo $file
	# Output names with file basename
	genomeA_genomeB=$(basename $file .bl)
	output_igorf=$genomeA_genomeB"_orf.txt"
	output_cds=$genomeA_genomeB"_cds.txt"
	
	# Picking best hits and sorting them in igorf-igorf or cds-cds files
	python3 parser.py -i Blast_outputs/$file -o output_igorf/output_igorf output_cds/$output_cds
done


