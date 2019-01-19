#!/usr/bin/bash
# 18 Jan 2019
# A. Vershinina
# usage:  ./create_gphocs_configs.sh loci.phy migrations.txt
# USE TOGETHER with ./create_gphocs_configs.sh
# migrations.txt - to name configs according to migrations they model

for n in 1 2 3
do
	for m in $(cat $2)
	do
		./create_gphocs_general_setup.sh ${1} $m ${n} > ${m}.config${n}
	done
done

echo "All done"
