#!/bin/sh

# How to Run:
# Run this script using sh 2_regenie_step2.sh on the command line on your machine

regenie_file_dir="/mnt/project/WGS_Lucia/Data/Input_regenie"
data_file_dir="/mnt/project/WGS_Lucia/Data"
wgs_dir="/mnt/project/WGS_Lucia/WGS_QC/Output"
dir="WGS_Lucia/Data/Output_regenie"

# Binary treat
cp "${regenie_file_dir}/phenos.BT.LOCO/phenos.BT.step1_pred.list" .
#sed -i "s|/tmp/|${regenie_file_dir}/phenos.BT.LOCO/|g" phenos.BT.step1_pred.list
sed "s|/tmp/|${regenie_file_dir}/phenos.BT.LOCO/|g" "phenos.BT.step1_pred.list" > "new.list"
dx upload new.list --path WGS_Lucia/Data/Input_regenie/phenos.BT.step1_pred_new.list

cp "${regenie_file_dir}/phenos.BT.LOCO/phenos.BT.step1_firth.list" .
#sed -i "s|/tmp/|${regenie_file_dir}/phenos.BT.LOCO/|g" phenos.BT.step1_pred.list
sed "s|/tmp/|${regenie_file_dir}/phenos.BT.LOCO/|g" "phenos.BT.step1_firth.list" > "new_firth.list"
dx upload new_firth.list --path WGS_Lucia/Data/Input_regenie/phenos.BT.step1_firth_new.list
r -p "/phenos.BT"

run_regenie_step2="regenie --step 2 --bt \
  --out phenos.BT.step2 \
  --bgen "${wgs_dir}/OPRM1.bgen" \
  --sample "${wgs_dir}/OPRM1.sample" \
  --ref-first \
  --phenoFile "${data_file_dir}/phenotypes/phenotypes.opioids.tsv" \
  --covarFile "${regenie_file_dir}/covariates.tsv" \
  --pred "${regenie_file_dir}/phenos.BT.step1_pred_new.list" \
  --firth --approx \
  --use-null-firth "${regenie_file_dir}/phenos.BT.step1_firth_new.list" \
  --bsize 200 \
  --verbose
"

dx run swiss-army-knife \
   -icmd="${run_regenie_step2}" --tag="Step2_regenie_BT" --instance-type "mem1_ssd1_v2_x16"\
   --destination="/WGS_Lucia/Data/Output_regenie" \
   -iimage="ghcr.io/rgcgithub/regenie/regenie:v3.2.6.gz" --yes;

