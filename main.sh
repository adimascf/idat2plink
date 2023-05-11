#!/usr/bin/bash

# If the sub program give non zero output, this script will immedietely exit
set -e
set -u
set -o pipefail

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "A simple program to covert .idat files to plink format files."
   echo
   echo "Options:"
   echo "-b     A path to .bpm manifest."
   echo "-s     A path to .csv manifest."
   echo "-c     A path to cluster .egt."
   echo "-i     A path to idat files directory."
   echo "-o     A path to gtc output directory."
   echo "-g     A path to reference genome .fasta."
   echo "-p     A prefix for output file."
   echo "-h     Show this help and exit"
   echo
}


################################################################################
# Create flag options                                                          #
################################################################################
BPM_MANIFEST_PATH=''
CSV_MANIFEST_PATH=''
EGT_CLUSTER_PATH=''
IDAT_FILES_PATH=''
OUTPUT_GTC_PATH=''
REF_GENOME_PATH=''
OUT_PREFIX=''


while getopts 'b:s:c:i:o:g:p:hv' flag;
do
  case "${flag}" in
    b) BPM_MANIFEST_PATH="${OPTARG}" ;;
    s) CSV_MANIFEST_PATH="${OPTARG}" ;;
    c) EGT_CLUSTER_PATH="${OPTARG}" ;;
    i) IDAT_FILES_PATH="${OPTARG}" ;;
    o) OUTPUT_GTC_PATH="${OPTARG}" ;;
    g) REF_GENOME_PATH="${OPTARG}" ;;
    p) OUT_PREFIX="${OPTARG}" ;;
    h) Help
        exit 1 ;;
  esac
done


################################################################################
# Main program                                                                 #
################################################################################

# Convert .idat to gtc.files
iaap-cli gencall $BPM_MANIFEST_PATH $EGT_CLUSTER_PATH $OUTPUT_GTC_PATH -f $IDAT_FILES_PATH -g -t 4

# Convert .gtc to .vcf files
export BCFTOOLS_PLUGINS="$HOME/bcftools-plugin/"

bcftools +gtc2vcf -Oz \
  --no-version \
  --bpm $BPM_MANIFEST_PATH \
  --csv $CSV_MANIFEST_PATH \
  --egt $EGT_CLUSTER_PATH \
  --gtcs $OUTPUT_GTC_PATH \
  --fasta-ref $REF_GENOME_PATH \
  --extra $OUT_PREFIX.tsv | \
  bcftools sort -Oz -T ./bcftools-sort.XXXXXX | \
  bcftools norm --no-version -Oz -c x -f $REF_GENOME_PATH | \
  tee $OUT_PREFIX.vcf.gz | \
  bcftools index --force --output $OUT_PREFIX.vcf.csi


# Convert .vcf file to plink format files
bcftools norm -Ou -m -any $OUT_PREFIX.vcf.gz |
  bcftools norm -Ou -f $REF_GENOME_PATH |
  bcftools annotate -Ob -x ID \
    -I +'%CHROM:%POS:%REF:%ALT' |
  plink --bcf /dev/stdin \
    --keep-allele-order \
    --vcf-idspace-to _ \
    --const-fid \
    --allow-extra-chr 0 \
    --split-x b38 no-fail \
    --make-bed \
    --out $OUT_PREFIX
