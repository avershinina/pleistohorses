#!/usr/local/bin/bash
# 23 Oct 2018
# A. Vershinina
# Goal: convert BAM files to FASTA files using ANGSD. Create two sets of fastas: with thransitions and without transitions.

HOME=/projects/path
FILES=/projects/path/f_hat/*.bam
ANGSD=/soe/avershinina/tools/angsd/angsd
FILTERS='-minQ 25 -minMapQ 25 -uniqueOnly -setMinDepth 5 -setMaxDepth 100 -nThreads 10 -howOften 1000'
REF=${HOME}/horse-genomes/Equus_cab_nucl_wChrUn.fasta

echo "Starting conversion, transitions included"

for SAMPLE in ${FILES}; do
	NAME=$(echo ${SAMPLE} | sed 's/[.].*//')
	echo "Making w_Ti fasta for ${NAME}"
	$ANGSD -doFasta 3 -doCounts 1 $FILTERS -i $SAMPLE -out ${NAME}_w_Ti
done
echo "With Ti conversion done"

echo "Starting conversion, transitions excluded" ## This option currently does not work. ANGSD gives segfault.

for SAMPLE in ${FILES}; do
	NAME=$(echo ${SAMPLE} | sed 's/[.].*//')
	echo "Making wo_Ti fasta for ${NAME}"
	$ANGSD -doFasta 3 -doCounts 1 $FILTERS -rmTrans 1 -ref $REF -i $SAMPLE -out ${NAME}_wo_Ti
done
echo "Without Ti conversion done"


mkdir fastas_w_Ti
mkdir fastas_wo_Ti
OUT_w_Ti=/fastas_w_Ti
OUT_wo_Ti=/fastas_wo_Ti

mv *_w_Ti* $OUT_w_Ti
mv *_wo_Ti* $OUT_wo_Ti

