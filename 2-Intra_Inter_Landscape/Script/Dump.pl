open IN, "/data2/share/home/zhangzhiqin/data/STR/New_Anchorwave_STR_20250103/list";
while(<IN>){
   chomp;
   @a=split/\t/;
   $acc=$_;
   $i+=1;
   if($i>0 and $i<15){
   $out="$i.pbs";
   open OUT,">$out";
   print OUT "
   \#PBS -N $i
   \#PBS -l walltime=100:30:00
   \#PBS -l nodes=1:ppn=1
   \#PBS -l mem=40gb
   cd /data2/share/home/zhangzhiqin/data/STR/New_Anchorwave_STR_20250103/new_inspecies
    #/data2/share/software/perl/bin/perl ../bin/extract_str_paired_sequence1.pl  /data2/share/home/zhangzhiqin/data/Line/anchorwave/Ath/point/result/Final_$acc\_Ath.txt /data2/share/home/zhangzhiqin/data/STR/Trf_STR/SSR/Ath.1.bed  Ath_$acc\_seq Ath
   /data2/share/software/perl/bin/perl ../bin/extract_str_paired_sequence.pl  /data2/share/home/zhangzhiqin/data/Line/anchorwave/Ath/point/result/Final_5-15_$acc.txt /data2/share/home/zhangzhiqin/data/STR/Trf_STR/SSR/5-15.1.bed  5-15_$acc\_seq 5-15
  
   ";
   system("qsub $out");
   }
}
