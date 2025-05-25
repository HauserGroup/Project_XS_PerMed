#!/bin/sh

# How to Run:
# Run this script using sh 2_regenie_step2.sh on the command line on your machine

regenie_file_dir="/mnt/project/WGS_Lucia/Data/Input_regenie"
data_file_dir="/mnt/project/WGS_Lucia/Data"
wgs_dir="/mnt/project/WGS_Lucia/WGS_QC/Output"
dir="WGS_Lucia/Data/Output_regenie"

# survival treat
cp "${regenie_file_dir}/phenos_all_users.survival.LOCO/phenos_all_users.survival.step1_pred.list" .
#sed -i "s|/tmp/|${regenie_file_dir}/phenos.survival.LOCO/|g" phenos.survival.step1_pred.list
sed "s|/tmp/|${regenie_file_dir}/phenos_all_users.survival.LOCO/|g" "phenos_all_users.survival.step1_pred.list" > "new.list"
dx upload new.list --path WGS_Lucia/Data/Input_regenie/phenos_all_users.survival.step1_pred_new.list


run_regenie_step2="regenie --step 2 \
  --out phenos.survival.step2 \
  --bgen "${wgs_dir}/OPRM1.bgen" \
  --sample "${wgs_dir}/OPRM1.sample" \
  --ref-first \
  --phenoFile ${data_file_dir}/phenotypes/phenotypes_all_users_survival_analysis.tsv \
  --covarFile ${regenie_file_dir}/covariates.tsv \
  --t2e \
  --phenoColList Available_medication_days,Available_medication_days_to_F_comorbidity \
  --eventColList Treatment_end,F_comorbidity_event \
  --pred "${regenie_file_dir}/phenos_all_users.survival.step1_pred_new.list" \
  --firth --approx \
  --vc-tests skato,acato-full \
  --bsize 200 \
  --set-list "${wgs_dir}/OPRM1.setlist" \
  --anno-file "${wgs_dir}/OPRM1.annotations" \
  --mask-def "${wgs_dir}/OPRM1_morphine.mask" \
  --verbose
"

dx run swiss-army-knife \
   -icmd="${run_regenie_step2}" --tag="Step2_regenie_survival" --instance-type "mem1_ssd1_v2_x16"\
   --destination="/WGS_Lucia/Data/Output_regenie/survival/morphine_codeine/all_users/burden_test" \
   -iimage="ghcr.io/rgcgithub/regenie/regenie:v4.1.gz" --yes;

