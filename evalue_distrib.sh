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
  wget -O Blast_yeasts.tar.gz transfert.u-psud.fr/nq01n
  gzip -dc Blast_yeasts.tar.gz > Blast_yeasts.tar
  tar -xvf Blast_yeasts.tar > Blast_outputs/
fi




