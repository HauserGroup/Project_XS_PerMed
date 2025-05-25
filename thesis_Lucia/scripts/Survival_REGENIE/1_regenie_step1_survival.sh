#!/bin/sh

# How to Run:
# Run this script using sh 1_regenie_step1.sh on the command line on your machine

#output directory - this should also be where the files in 02-step1-qc-filter.sh end up
data_file_dir="/mnt/project/WGS_Lucia/Data"
regenie_file_dir_J="/mnt/project/WGS_Javier/Data/Input_regenie"
regenie_file_dir_L="/mnt/project/WGS_Lucia/Data/Input_regenie"
dir_J="WGS_Javier/Data/Input_regenie"
dir_L="WGS_Lucia/Data/Input_regenie"

# Binary treat
run_regenie_step1="regenie --step 1 \
 --out phenos.survival.step1 \
 --bed ukb_allChrs \
 --phenoFile ${data_file_dir}/phenotypes/phenotypes_all_users_survival_analysis.tsv --covarFile ${regenie_file_dir_L}/covariates.tsv \
 --t2e\
 --phenoColList Available_medication_days,Available_medication_days_to_F_comorbidity \
 --eventColList Treatment_end,F_comorbidity_event \
 --extract ${regenie_file_dir_J}/WGS_qc_pass.snplist --keep ${regenie_file_dir_J}/WGS_qc_pass.id \
 --bsize 1000 \
 --lowmem --lowmem-prefix tmp_preds \
 --verbose --threads 16
"

dx run swiss-army-knife -iin="${dir_J}/ukb_allChrs.bed" \
   -iin="${dir_J}/ukb_allChrs.bim" \
   -iin="${dir_J}/ukb_allChrs.fam" \
   -icmd="${run_regenie_step1}" \
   --tag="Step1_regenie_BT" --instance-type "mem1_ssd1_v2_x16" --destination="${dir_L}/phenos_all_users.survival.LOCO" --brief --yes \
   -iimage="ghcr.io/rgcgithub/regenie/regenie:v4.1.gz" --yes
