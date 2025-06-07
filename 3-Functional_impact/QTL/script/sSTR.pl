for $i (1..5){
    $name="A_S_chr$i.pbs";
    open OUT, ">$name";
    print OUT "\#PBS \-N AS_S_chr$i";
    print OUT "
    \#PBS -l nodes=node4:ppn=1
    \#PBS -l walltime=24:00:00
    \#PBS -S /bin/bash
    cd $PBS_O_WORKDIR
    ";
    print OUT "
    source activate QTL
    python3 LinRegAssociationTest_v2.py \\
    --chrom  $i \\
    --expr ../sQTL/sse.csv \\
    --exprannot ../sQTL/gencode_AS.csv \\
    --strgt ../eQTL/STR_flt.tab.gz \\
    --distfromgene 2000 \\
    --out ../sQTL_SSE_No/STR/chr$i.tab \\
    --norm   \\
    --tmpdir tmp
    ";
   # system("qsub $name");
}
