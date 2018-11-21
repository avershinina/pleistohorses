#!/usr/local/bin/bash
# 20 Nov 2018
# A. Vershinina
# Goal: run fhat with different combinations of BAM files using James's program.
# Source for fhat and dstat programs: https://github.com/jacahill/Admixture
# calc with transitions
# Requirement: create a text file with all possible combinations for genomes of interest using create_combinations.py
# It can also be just a file with one line:
# fasta1 fasta2 fasta3 fasta4
# (separated by space).

read -p 'Outgroup .fasta: ' OG
read -p 'Combinations in .txt: ' COMBOS

FHAT=/soe/avershinina/tools/Admixture/Fhat
FHAT_PARSE=/soe/avershinina/tools/Admixture/F_hat_parser.py
JACK=/soe/avershinina/tools/Admixture/weighted_block_jackknife_fhat.py

BLOCK=5000000

while IFS=' ' read p1 p2 p3 p4
do 
	$FHAT $p1 $p2 $p3 $p4 $OG $BLOCK > ${p1}${p2}${p3}${p4}_OG.fhat
done < $COMBOS 
wait

for f in *_OG.fhat
do
	python $FHAT_PARSE ${f} > ${f}.admx
	python $JACK ${f} $BLOCK > ${f}.err
done
wait

# calc without transitions

FHAT_TV=/soe/avershinina/tools/Admixture/Fhat_tv

while IFS=' ' read p1 p2 p3 p4
do 
	$FHAT_TV $p1 $p2 $p3 $p4 $OG $BLOCK > ${p1}${p2}${p3}${p4}_OG_noTV.fhat
done < $COMBOS 
wait

for f in *_OG_noTV.fhat
do
	python $FHAT_PARSE ${f} > ${f}.admx
	python $JACK ${f} $BLOCK > ${f}.err
done
wait
echo "All done"