#!/usr/local/bin/bash
# 20 Nov 2018
# A. Vershinina
# Goal: run fhat with different combinations of BAM files using James's program.

DSTAT=/soe/avershinina/tools/Admixture/Dstat
FHAT=/soe/avershinina/tools/Admixture/Fhat
FHAT_PARSE=/soe/avershinina/tools/Admixture/F_hat_parser.py
OG=
BLOCK=5000000


Dstat P1_all.fa P2_all.fa P3_all.fa P4_all.fa OG_all.fa 5000000 > P1_P2_P3_P4_OG.fhat

C=$(echo 'for combo in  {BAM1,BAM2,BAM3}{BAM1,BAM2,BAM3}{BAM1,BAM2,BAM3}; do echo $combo; done | egrep -v 'BAM1.*BAM1|BAM2.*BAM2|BAM3.*BAM3' | cut --output-delimiter=$'\n' -c1-4,5-9,10-14')

for combo in  {BAM1,BAM2,BAM3}{BAM1,BAM2,BAM3}{BAM1,BAM2,BAM3}; do echo $combo; done | egrep -v 'BAM1.*BAM1|BAM2.*BAM2|BAM3.*BAM3' | cut --output-delimiter=$' ' -c1-4,5-8,9-14 > combos.txt
