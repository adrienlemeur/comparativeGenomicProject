#!/bin/bash
clear

files="ishouldnotsearchthis"

while read A;do
	files="$files|$A"
	OUTPUT=$(ls artificial_files|grep -E $files)

	#cat
	#super_finder
	#clique_search

done < strain_names.txt



#Avec les seuils


while read A;do

	echo
	#cat
	#super_finder
	#clique_search

done < evalue_threshold.txt
