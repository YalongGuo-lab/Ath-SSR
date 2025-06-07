for $i (1..5){
    $name="chr$i.pbs";
    open OUT, ">$name";
    print OUT "\#PBS \-N R$i";
    print OUT "
    \#PBS -l nodes=node1:ppn=1
    \#PBS -l walltime=24:00:00
    cd $PBS_O_WORKDIR
    ";
    print OUT "
    source activate QTL
    python3 LinRegAssociationTest_v2.py \\
    --chrom  $i \\
    --expr ../eQTL/Corr_Expr.csv \\
    --exprannot ../eQTL/gencode_gene_annotation_Col.csv \\
    --strgt ../eQTL/STR_flt.tab.gz \\
    --distfromgene 2000 \\
    --norm   \\
    --out  ../confine/STR/chr$i.tab \\
    --tmpdir \/tmp
    ";
    system("qsub $name");
}
