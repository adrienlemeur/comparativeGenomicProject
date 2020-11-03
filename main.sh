#!/bin/bash
# Script bash pour la boucle principale

#------------------------------------------
# Récupération et organisation des données
#------------------------------------------

# On se place dans le répertoire du projet qui contient uniquement prot.tar
tar -xvf prot.tar # dézippage

# Téléchargement de l'outil blast
wget -O ncbi-blast-2.10.1+-x64-linux.tar.gz ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.10.1+-x64-linux.tar.gz
gunzip ncbi-blast-2.10.1+-x64-linux.tar.gz # on dézippe
tar -xvf ncbi-blast-2.10.1+-x64-linux.tar # on dé-tar

chmod +x ncbi-blast-2.10.1+/bin # droit d'utilisation sur toutes les fonctions

# Création des 27 bases de données
if [ ! -f Blast_db ];then
  mkdir Blast_db
fi

for A in prot/* do
  basenm = basename $A
  /ncbi-blast-2.10.1+/bin/makeblastdb -in prot/A -dbtype "prot" -out Blast_db/basenm
done 

# Dossier de sortie des alignements
if [ ! -f Blast_ouput ];then
  mkdir Blast_ouput
fi

# Réalisation des 21*21 alignements
for A in prot/* do
  for B in prot/* do
    database = basename $B
    base_name = basename $A
    output_name = paste base_name _ database # A_B
    echo $output_name
    ./ncbi-blast-2.10.1+/bin/blastp -query prot/base_name.fa -db Blast_db/database -out Blast_output/output_name.txt -outfmt '7 qseqid sseqid pident length mismatch gapopen qstart qen sstart send evalue bitscore qlen slen gaps'
  done 
done 

# Fin de cette partie : 21x21 fichiers txt

#------------------------------------------
# Traitement des données
#------------------------------------------









#------------------------------------------
# Résultats
#------------------------------------------
