# !/bin/bash 
for sample in *.bam
do
	echo $sample
	NAME=$(echo ${sample} | sed ‘s/.bam//’)
	echo $describer

# Sort BAM file
	samtools sort ${NAME}.bam ${NAME}.sort.bam

# index the bam file
	samtools index ${NAME}.sort.bam

# Remove intermediate files
#	rm ${NAME}.uns.bam
done

echo ${sample} | sed ‘s/.bam//’
