#!/usr/local/bin/bash
# A. Vershinina
# Goal: take your BAM file, add RG and other flags, recalibrate using mapdamage

OUT_DIR=/path/to/out
cd ${OUT_DIR}
BAM=yourfile.bam
REFERENCE_SEQUENCE=ref.file.fa
PICARD_TOOLS=/path/picard-tools-1.110
GATK="java -Xmx40G -jar /path/GenomeAnalysisTK.jar"
MAPDAMAGE2=/path/mapDamage		
SEQ_LENGTH=25		# The number of nucleotides to use at the 5' and 3' ends of the read
MAX_READ_LENGTH=150		# The maximum read length to consider
mkdir /path/recal
RECAL_OUT=/path/recal

#--------------
# RG
#--------------

java -jar ${PICARD_TOOLS}/AddOrReplaceReadGroups.jar INPUT=${BAM} OUTPUT=${OUT_DIR}/genome.RG.bam RGID=genome_rgid RGLB=genome_rglb RGPL=Illumina RGPU=genome_rgpu RGSM=genome_rgsm VALIDATION_STRINGENCY=SILENT

samtools index ${OUT_DIR}/genome.RG.bam

#--------------
# Realign
#--------------

${GATK} -T RealignerTargetCreator -I ${OUT_DIR}/genome.RG.bam -R ${REFERENCE_SEQUENCE} -o ${OUT_DIR}/genome.RG.intervals

${GATK} -T IndelRealigner -I ${OUT_DIR}/genome.RG.bam -R ${REFERENCE_SEQUENCE} -o ${OUT_DIR}/genome.RG.indelRealigned.bam --filter_bases_not_stored -targetIntervals ${OUT_DIR}/genome.RG.intervals

echo "Realignment is complete. Don't forget to remove intermediate files!"

samtools index ${OUT_DIR}/genome.RG.indelRealigned.bam

#--------------
# Recalibrate
#--------------

${MAPDAMAGE2} -i ${OUT_DIR}/genome.RG.indelRealigned.bam -r ${REFERENCE_SEQUENCE} --verbose --rescale --seq-length ${SEQ_LENGTH} -l ${MAX_READ_LENGTH} -d ${RECAL_OUT} -fix-nicks

echo "MapDamage rescaling finished"
