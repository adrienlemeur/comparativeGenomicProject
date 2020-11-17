#!/bin/bash
clear

files="ishouldnotsearchthis"

mkdir -p test_folder
i=1

while read A;do
	echo $i
	files="$files|$A"
		
	OUTPUT=$(find blast_outputs|grep -E $files -w)
	echo $OUTPUT

	#echo "#Genomes:\n"$files | sed -e 's/ishouldnotsearchthis'\|'/#/g' | sed -e 's/'\|'/\\n#/g' > test_folder/$i"_genomes.txt"
	#cat $OUTPUT | grep "^[^#;]" | cut -f 1,2,3,4,12 >> test_folder/$i"_genomes.txt"

	i=$((i + 1))
done < strain_names.txt



#Avec les seuils
<<///
while read A;do

	echo
	#cat
	#super_finder
	#clique_search

done < evalue_threshold.txt
///
