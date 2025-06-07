open IN, "$ARGV[0]";
open OUT, ">$ARGV[1]";
while(<IN>){
      chomp;
      @a=split/\s+/;
      if(/@/){
         s/\@//g;
         $head= $_;
       }else{
         @b=split/\_/,$head;
         print OUT  "$b[0]\t$b[1]\t$b[2]\t$a[2]\t$a[3]\t$a[13]\t$a[14]\n";
       }
}
