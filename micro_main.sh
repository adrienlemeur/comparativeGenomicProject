#!/bin/bash

while test $# -gt 0; do
	case "$1" in
		-id)
			shift
			identity=$1
			shift
		;;

		-cov)
			shift
			coverage=$1
			shift
		;;
		
		-eval)
			shift
			evalue=$1
			shift
		;;

		--nostart)
			starting='FALSE'
			break
		;;

		*)
			echo "$1 is not a recognized flag!"
			break
		;;
	esac
done


cat blast_outputs/*.bl | grep "^[^#;]" | cut -f 1,2,3,4,12 > "reciprocity/best_hits_list.txt"
python3 supairFinder.py -i "reciprocity/best_hits_list.txt" -o "reciprocity/reciprocity_list.txt" --seuil_identite ${identity} --seuil_coverage ${coverage} --seuil_evalue ${evalue}
python3 cliqueSearch.py -i "reciprocity/reciprocity_list.txt" 21 -o "cliques/cliques.txt" "cliques/cliques_max.txt"

core_genome_size=$(cat cliques/cliques_max.txt | wc -l)
echo "Le nombre de cliques maximales et donc d'éléments dans le core génome est de : "${core_genome_size}"."
