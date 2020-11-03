#!/usr/bin/env python3
'''
    File name: parser.py
    Author: Adrien Le Meur
    Date created: 03/10/2020
    Date last modified: 03/10/2020
    Python Version: 3.0
'''
import sys

#__________ARGS__________ARGS__________ARGS__________ARGS__________ARGS__________ARGS

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
