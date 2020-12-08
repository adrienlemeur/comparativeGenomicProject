#!/bin/sh

#parallel --joblog time.log --jobs 2 sh paramain.sh ::: 70 ::: 60 :::: evalue_thresholds.txt

starting="FALSE"
coverage=$1
identity=$2
eval_from_file=$3


python3 supairFinder.py -i "reciprocity/best_hits_list.txt" -o "reciprocity/reciprocity_list_$eval_from_file.txt" --seuil_identite ${identity} --seuil_coverage ${coverage} --seuil_evalue ${eval_from_file}

mkdir -p cliques

for nombre_genome in $(seq 2 21)
do
	python3 cliqueSearch.py -i "reciprocity/reciprocity_list_$eval_from_file.txt" ${nombre_genome} -o "cliques/$nombre_genome""_$eval_from_file""_cliques.txt" "cliques/$nombre_genome""_$eval_from_file""_cliques_max.txt"
	(printf $eval_from_file"\t"$nombre_genome"\t"; cat "cliques/$nombre_genome""_$eval_from_file""_cliques_max.txt" | wc -l ) >> cliques/table_cliques_max_$eval_from_file.txt
done
echo $eval_from_file "DONE"
