my $dir = '/data2/share/home/zhangzhiqin/data/Line/anchorwave/Ath/point/result';  # 替换为你的目录路径
my @files = glob("$dir/*Final*$ARGV[0]*");
foreach my $file (@files){
   $i+=1;
   @a=split/\_/,$file;
   if($i>0 and $i<13){
   if($a[2]=~/$ARGV[0]/){
      $acc=$a[1];
   }else{
      $acc=$a[2];
   }
   $out="test$i.pbs";
   open OUT,">$out";
   print OUT "
   \#PBS -N $i
   \#PBS -l walltime=100:30:00
   \#PBS -l nodes=1:ppn=1
   \#PBS -l mem=40gb
   cd /data2/share/home/zhangzhiqin/data/STR/New_Anchorwave_STR_20250103/inspecies
   /data2/share/software/perl/bin/perl ../bin/extract_str_paired_sequence.pl  $file  /data2/share/home/zhangzhiqin/data/STR/Trf_STR/SSR/$ARGV[0].1.bed  $ARGV[0]_$acc\_seq $ARGV[0]
  
   ";
   system("qsub $out");
   }
}
