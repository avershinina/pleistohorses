#!/usr/bin/bash
# 18 Jan 2019
# A. Vershinina
# usage: script.sh locifile.phy migration number > locifile.config
echo "GENERAL-INFO-START"
echo -e "\t\tseq-file\t\t${1}"
echo -e "\t\ttrace-file\t\t${2}.trace${3}"
echo -e "\t\tnum-loci\t\t4215"
echo -e "\t\tburn-in\t\t0"
echo -e "\t\tmcmc-iterations\t\t10000000"
echo -e "\t\tmcmc-sample-skip\t\t10"
echo -e "\t\tstart-mig\t\t100000"
echo -e "\t\titerations-per-log\t\t100"
echo -e "\t\tlogs-per-line\t\t100"
echo -e "\t\ttau-theta-print\t\t1000"
echo -e "\t\ttau-theta-alpha\t\t1"
echo -e "\t\ttau-theta-beta\t\t20000"
echo -e "\t\tmig-rate-print\t\t0.1"
echo -e "\t\tmig-rate-alpha\t\t0.002"
echo -e "\t\tmig-rate-beta\t\t0.00001"
echo -e "\t\tlocus-mut-rate\t\tVAR\t\t1.0"
echo -e "\t\tfind-finetunes\t\tTRUE"
echo -e "\t\tfind-finetunes-num-steps\t\t100"
echo -e "\t\tfind-finetunes-samples-per-step\t\t10"
