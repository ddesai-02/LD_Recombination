#!/bin/bash
#SBATCH --account=def-shaferab
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --time=23:59:00

# Load Modules
module load bcftools vcftools java

# Inputs
VCF="Ursmar_filt_v3.vcf.gz"
BEAGLE_JAR="/home/devan/software/beagle.27Feb25.75f.jar"
SCAFFOLDS="scaffolds.txt"

# Normalize VCF
bcftools norm -d all "$VCF" -O z -o Norm.vcf.gz
bcftools index Norm.vcf.gz

# Main Loop: Phase Scaffolds and Convert to LD Format

while read -r scaffold; do
    echo "============================================"
    echo "Processing scaffold: $scaffold"
    echo "============================================"

    # 1. Extract the raw unphased scaffold to a temporary file
    bcftools view Norm.vcf.gz -r "$scaffold" -O z -o "tmp_${scaffold}.vcf.gz"

    # 2. Phase the single scaffold
    echo "Phasing $scaffold with Beagle..."
    java -Xmx14g -jar "$BEAGLE_JAR" \
        gt="tmp_${scaffold}.vcf.gz" \
        out="tmp_phased_${scaffold}" \
        nthreads=4

    # 3. Pass the phased single-scaffold VCF directly to VCFtools
    echo "Exporting to LDhat format..."
    vcftools --gzvcf "tmp_phased_${scaffold}.vcf.gz" --chr "$scaffold" --ldhat --out "${scaffold}"

    # 4. Clean up intermediate single-scaffold files
    rm "tmp_${scaffold}.vcf.gz" "tmp_phased_${scaffold}.vcf.gz" "tmp_phased_${scaffold}.log"

done < "$SCAFFOLDS"
