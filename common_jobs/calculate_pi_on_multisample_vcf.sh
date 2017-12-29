#!/usr/local/bin/tcsh
foreach IND (`cat sample_names.txt`) # each sample can be at a new line
	vcftools --gzvcf multisample.vcf.gz --indv $IND --window-pi 100000 --out $IND.100kb
end
wait
echo "Pi is calculated"
