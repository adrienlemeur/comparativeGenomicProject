#!/bin/bash

cat blast_outputs/*.bl | grep "^[^#;]" | cut -f 1,2,3,4,12 > "reciprocity/best_hits_list.txt"
python3 supairFinder.py -i "reciprocity/best_hits_list.txt" -o "reciprocity/reciprocity_list.txt" --seuil_identite ${identity} --seuil_coverage ${coverage} --seuil_evalue ${evalue}
python3 cliqueSearch.py -i "reciprocity/reciprocity_list.txt" 21 -o "cliques/cliques.txt" "cliques/cliques_max.txt"
