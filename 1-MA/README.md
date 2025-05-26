#  MA line STR Variant Calling Summary

This section provides a brief explanation of the files and directories related to STR calling in mutation accumulation (MA) lines:

Folders contain the following:

- `Run_CallingSTR.pbs`:
   PBS submission script used to detect STR variants in MA lines and apply filtering criteria.
- `MA_Sample_Depth.txt`:
   Tab‑delimited file listing sequencing depth for each MA line sample, used to verify coverage.
- `Raw_vcf/`:
   Directory containing the resulting VCF files (raw and filtered) for each MA line sample after STR calling.
- `Calling_File/`:
   Directory containing files used to calculate mutation rates.
- `Miu`:
   Files with calculated mutation rate results; each tab in these files corresponds to an input used for generating plots in Figure 1.
