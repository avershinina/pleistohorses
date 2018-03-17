#!/usr/local/bin/bash
# 16 Mar 2018
# A. Vershinina
# Goal: run GATK

function usage {
echo "Usage:
        $0 <ref.fa file> <bam files>*
    Where <bam files>* is a list of bam files that you want to generate vcf files for."
exit 1
}

if [ $# -le 1 ]
then
  usage
fi

REF=$1
shift


JAVA='java -Xmx50G -jar'
GATK=/soe/avershinina/tools/GenomeAnalysisTK.jar

for file in $@
do
echo "Processing $file..."
filename="${file%.*}"
	${JAVA} ${GATK} -T HaplotypeCaller \ 
	–R {$REF} \ 
	–I "$filename".bam \  
	–o "$filename".g.vcf \ 
	–ERC GVCF
echo "Done HaplotypeCaller with $filename"
### FINISH BELOW
java –jar 
GenomeAnalysisTK.jar
–T 
GenotypeGVCFs
 \ 
–R 
human.fasta
 \ 
–V sample1.g.vcf \ 
–V sample2.g.vcf \ 
–V 
sampleN.g.vcf
 \ 
–o 
output.vcf
