#!/usr/bin/env python3
'''
    File name: parser.py
    Author: Adrien Le Meur
    Date created: 03/10/2020
    Date last modified: 03/10/2020
    Python Version: 3.0
'''

#__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT__________INPUT

try:
	genome_file_1 = sys.argv[sys.argv.index("-file_1")+1]
except :
	sys.exit()

try:
	genome_file_2 = sys.argv[sys.argv.index("-file_2")+1]
except :
	sys.exit()

#__________FUNCTION__________FUNCTION__________FUNCTION__________FUNCTION__________FUNCTION__________FUNCTION

#input : multi_fasta file and a genome name
#output : a 2 level dictionnary -> genome_dict -> genome_dict[genome_name] {gene_name : DNA sequence}

def fasta_parser(multi_fasta, genome_name)
	genome_dict = {}
	genome_dict[genome_name] = {}

	with open(multi_fasta) as mf:
		lines = mf.readlines()

		for current_line in lines :
			if current_line[0] == '>' :
				gene_name = current_line
			else :
				genome_dict[genome_name][gene_name] = current_line.rstrip().replace('\n', '')
	return(genome_dict)

#input : 2 multifasta files names and 2 genome names

def genome_comparison(genome_1, genome_2):
	name_1 = genome_1.split('.');
	name_2 = genome_2.split('.');
	
	dict_genome_1 = fasta_parser(genome_1, name_1)
	dict_genome_2 = fasta_parser(genome_2, name_2)
	
#__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN__________MAIN

genome_comparison(genome_file_1, genome_file_2)


