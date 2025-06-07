# Ath-SSR


Code and analysis for genome-wide analysis of STRs in Arabidopsis

Folders contain the following:

- `1-MA`:
   Directory containing files used to calculate mutation rates.
- `2-Intra_Inter_Landscape`:
   Scripts and documentation for conducting intra-species and inter-species STR analysis.
- `3-Functional_impact`:
  Scripts and files for STR-based QTL analysis.
- `4-Heritability`:
   Pipeline and files for STR-based heritability estimation.




## Repository layout

| Folder | Purpose | Typical contents | Main outputs |
| ------ | ------- | ---------------- | ------------ |
| **1-MA**<br>(Mutation-Accumulation) | Estimate per-locus and genome-wide STR mutation rates from Arabidopsis MA lines. | • Pre-filtered VCFs for each MA line<br>• `estimate_mu.py` + helper modules<br>• `config.yaml` with genome build, motif sizes, quality thresholds | • `mu_per_locus.tsv` – mutation rate per STR<br>• `mu_genomewide.txt` – overall STR mutation rate |
| **2-Intra_Inter_Landscape** | Compare STR variation **within** A. thaliana populations and **between** Arabidopsis species. | • Population-level STR VCFs (e.g. 1001 Genomes)<br>• Cross-species STR alignment files<br>• R notebooks (`landscape.Rmd`) for diversity metrics & plots | • Allele-frequency spectra<br>• π, He, and other diversity tables<br>• PDF/PNG landscape figures |
| **3-Functional_impact** | Link STR variation to phenotypes via QTL mapping and functional annotation. | • Snakemake workflow (`Snakefile`)<br>• Phenotype matrices (.csv)<br>• Annotation sets (GFF3, GO, Pfam)<br>• Scripts for Manhattan plots & candidate-gene ranking | • `qtl_hits.tsv` – significant STR-trait associations<br>• Annotated candidate-gene tables<br>• Manhattan & QQ plots |
| **4-Heritability** | Partition phenotypic variance into STR-based and SNP-based components. | • Wrapper scripts for LDSC and GCTA (`run_ldsc.sh`, `run_gcta.sh`)<br>• Genetic relationship matrices<br>• Trait phenotype files | • `h2_str_vs_snp.txt` – heritability estimates with SEs<br>• Bar plots comparing STR vs. SNP contributions |

> **Tip:** Each sub-folder contains a brief `README.md` outlining required software, command examples, and expected runtimes.
