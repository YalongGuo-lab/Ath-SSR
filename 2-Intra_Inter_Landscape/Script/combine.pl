#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# 定义变量
my $prefix;       # 文件前缀
my $output_file;  # 输出文件名

# 获取命令行参数
GetOptions(
    'prefix=s' => \$prefix,       # 输入文件前缀
    'output=s' => \$output_file,  # 输出文件名
) or die "用法: $0 --prefix <file_prefix> --output <output_file>\n";

# 检查是否指定了前缀和输出文件
if (!$prefix || !$output_file) {
    die "错误: 必须指定文件前缀和输出文件\n";
}

# 定义输入文件名
my @input_files = ("${prefix}.fix", "${prefix}.length", "${prefix}.naa");

# 检查输入文件是否存在
foreach my $file (@input_files) {
    if (!-e $file) {
        die "错误: 输入文件 '$file' 不存在\n";
    }
}

# 打开输出文件进行写入
open my $out_fh, '>', $output_file or die "无法打开输出文件 '$output_file': $!\n";

# 遍历每个输入文件并将内容写入输出文件
foreach my $file (@input_files) {
    # 打开输入文件进行读取
    open my $in_fh, '<', $file or die "无法打开输入文件 '$file': $!\n";

    if ($file =~ /\.fix$/) {  # 处理 .fix 文件
        while (my $line = <$in_fh>) {
            chomp $line;  # 去除换行符
            next if $line eq '';  # 跳过空行

            my @a = split /\t/, $line;
            if (@a >= 8) {  # 确保有足够的列
                print $out_fh "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$a[4]\tFix\n";
            }
        }
    }
    elsif ($file =~ /\.length$/) {  # 处理 .length 文件
        while (my $line = <$in_fh>) {
            chomp $line;  # 去除换行符
            next if $line eq '';  # 跳过空行

            my @a = split /\t/, $line;
            if (@a >= 13) {  # 确保有足够的列
                print $out_fh "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$a[12]\tLength\n";
            }
        }
    }
    elsif ($file =~ /\.naa$/) {  # 处理 .naa 文件
        while (my $line = <$in_fh>) {
            chomp $line;  # 去除换行符
            next if $line eq '';  # 跳过空行

            my @a = split /\t/, $line;
            print $out_fh "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\tNA\tNAA\n";
        }
    }

    # 关闭输入文件
    close $in_fh;
}

# 关闭输出文件
close $out_fh;

print "文件合并完成，输出文件：$output_file\n";
