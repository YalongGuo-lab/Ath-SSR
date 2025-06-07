
## prepare genotype in plink format
plink  --vcf test.vcf.gz --recode --out test --double-id
plink  --file test --make-bed --out test
plink --keep ID.kept.txt --bfile test --make-bed --maf 0.005 --out kept.test
plink --bfile kept.test --recode vcf --out kept.test
bgzip kept.test.vcf

## prune the genotype dataset
ldak --bfile kept.test --cut-weights snps --window-prune 0.98

## weighting
ldak --bfile kept.test  --calc-weights-all snps 1 > weights.out 

## calculate kinship
ldak  --calc-kins-direct LDAK-Thin --bfile  kept.test  --weights snps/weights.thin --power -.5 

## estimate heritability
ldak --pheno pheno.txt --mpheno 4  --grm LDAK-Thin  --covar pheno.cov --reml 4 --constrain YES
