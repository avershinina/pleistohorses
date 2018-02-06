#!/usr/local/bin/bash
# 5 Feb 2018
# A. Vershinina
# Goal: run a tool in several folders if it is impossible to specify output location in the tool options.

DATE='2018-02-5'
CLUMPP=/path/CLUMPP_Linux64.1.1.2/CLUMPP # Good example of such a tool
HOME=/path1

printf 'clumpp_K2 clumpp_K3 clumpp_Kn' >  clump_folders_${DATE}.txt

for FOLDER in $(cat clump_folders_${DATE}.txt) ; do
	cd ${HOME}/${FOLDER}/
	${CLUMPP}
	cd ${HOME}
  echo "Finished running" ${FOLDER}
	wait
done

