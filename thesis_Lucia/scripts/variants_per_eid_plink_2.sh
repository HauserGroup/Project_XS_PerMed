#!/bin/sh

# This script extracts genetic variants from a PLINK file, maps them to participant EIDs using a sample file, and exports the data in an allele-based format.

# How to Run:
# Run this script using: sh variants_eid.sh on the command line


#set output directory
data_file_dir="/WGS_Lucia/WGS_QC/Output/Drug_variant_matrix"

run_plink="plink2 --bfile OPRM1_missense_variants \
       --recode A \
       --out filtered_variants_per_eid"

dx run swiss-army-knife -iin="${data_file_dir}/OPRM1_missense_variants.bed" \
   -iin="${data_file_dir}/OPRM1_missense_variants.bim" \
   -iin="${data_file_dir}/OPRM1_missense_variants.fam" \
   -icmd="${run_plink}" --tag="Variants_per_eid" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${data_file_dir}" --brief --yes
