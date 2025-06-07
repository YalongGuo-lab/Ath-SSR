#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# 定义变量来存储外部传入的文件名
my $input_file;
my $fix_output;
my $length_output;
my $naa_output;
my $str_file;  # 新增Cru_STR.bed文件输入参数

# 获取命令行参数
GetOptions(
    'input=s'   => \$input_file,
    'fix=s'     => \$fix_output,
    'length=s'  => \$length_output,
    'naa=s'     => \$naa_output,
    'str=s'     => \$str_file,  # Cru_STR.bed 文件
) or die "Error in command line arguments.\n";

# 确保所有必需的参数都已提供
if (!$input_file || !$fix_output || !$length_output || !$naa_output || !$str_file) {
    die "Usage: $0 --input INPUT_FILE --fix FIX_FILE --length LENGTH_FILE --naa NAA_FILE --str STR_FILE\n";
}

# 打开输出文件
open my $fix_fh, '>', $fix_output or die "Cannot open $fix_output: $!";
open my $length_fh, '>', $length_output or die "Cannot open $length_output: $!";
open my $naa_fh, '>', $naa_output or die "Cannot open $naa_output: $!";  # 使用覆盖模式，避免重复

# 子例程：对碱基序列排序
sub sort_sequence {
    my ($sequence) = @_;
    my @bases = split //, $sequence;
    my @sorted_bases = sort @bases;
    return join '', @sorted_bases;
}

# 子例程：获取碱基互补
sub complement_sequence {
    my ($sequence) = @_;
    $sequence =~ tr/ATGC/TACG/;
    return $sequence;
}

# 哈希表存储第六列的值
my %col6_in_fix;
my %col6_in_length;
my %col6_in_naa;

# 哈希表存储fix和length的行
my %fix_rows;
my %length_rows;

# 读取输入文件并按第六列分组
open my $input_fh, '<', $input_file or die "Cannot open $input_file: $!";
my %grouped_rows;

while (my $line = <$input_fh>) {
    chomp $line;
    my @fields = split /\t/, $line;

    # 检查字段数量
    if (@fields >= 14) {
        my $col6 = $fields[5];
        push @{$grouped_rows{$col6}}, \@fields;
    } else {
        warn "Skipping incomplete line: $line\n";
    }
}
close $input_fh;

# 处理每个第六列的分组
foreach my $col6 (keys %grouped_rows) {
    my $rows = $grouped_rows{$col6};

    foreach my $fields (@$rows) {
        my $col5 = $fields->[4];
        my $col7_seq = $fields->[6];
        my $col8_seq = $fields->[7];
        my $col13 = $fields->[12];
        my $col14_seq = $fields->[13];
        my $col15_seq = $fields->[14];
        # 排序第7列和第14列的碱基序列
        my $sorted_col7 = sort_sequence($col7_seq);
        my $sorted_col14 = sort_sequence($col14_seq);

        # 获取第14列的互补序列并排序
        my $comp_col14_seq = complement_sequence($col14_seq);
        my $sorted_comp_col14 = sort_sequence($comp_col14_seq);

        # 判断第7列与第14列的序列是否相同或互补
       if($col8_seq eq $col15_seq){
            unless (exists $col6_in_fix{$col6}) {
                    $fix_rows{$col6} = $fields;
                    $col6_in_fix{$col6} = 1;
            }
        }elsif ($sorted_col7 eq $sorted_col14 || $sorted_col7 eq $sorted_comp_col14) {
            # 四舍五入判断第5列与第13列是否相等
            my $rounded_col5 = int($col5 + 0.5);
            my $rounded_col13 = int($col13 + 0.5);
            my $dis=abs($col5-$col13);
            if ($rounded_col5 == $rounded_col13 or $dis<1 ) {
                # 如果fix中还没有相同第六列的行，保存
                unless (exists $col6_in_fix{$col6}) {
                    $fix_rows{$col6} = $fields;
                    $col6_in_fix{$col6} = 1;
                }
             }else {
             # 保存第5列和第13列差值最小的行到length
             if (exists $length_rows{$col6}) {
                    my $prev_fields = $length_rows{$col6};
                    my $prev_diff = abs($prev_fields->[4] - $prev_fields->[12]);
                    my $curr_diff = abs($col5 - $col13);

                    if ($curr_diff < $prev_diff) {
                        $length_rows{$col6} = $fields;
                    }
              } else {
                    $length_rows{$col6} = $fields;
              }
              $col6_in_length{$col6} = 1;
            }
        }
    }
}

# 输出fix文件
foreach my $col6 (keys %fix_rows) {
    print $fix_fh join("\t", @{$fix_rows{$col6}}), "\n";
}

# 输出length文件，确保第六列不与fix重复
foreach my $col6 (keys %length_rows) {
    next if exists $col6_in_fix{$col6};
    print $length_fh join("\t", @{$length_rows{$col6}}), "\n";
}

# 从fix和length中获取所有第六列的值
my %existing_col6 = (%col6_in_fix, %col6_in_length);

# 处理NAA文件，确保第六列不与fix和length重复，且在NAA中唯一
foreach my $col6 (keys %grouped_rows) {
    # 跳过已在fix或length中的第六列
    next if exists $existing_col6{$col6};

    # 只保留第六列唯一的行
    unless (exists $col6_in_naa{$col6}) {
        my $fields = $grouped_rows{$col6}[0];  # 取第一个出现的行
        print $naa_fh join("\t", @$fields), "\n";
        $col6_in_naa{$col6} = 1;
    }
}

# 处理Cru_STR.bed文件，将第六列未出现在fix、length和NAA中的行追加到NAA
open my $str_fh, '<', $str_file or die "Cannot open $str_file: $!";
while (my $line = <$str_fh>) {
    chomp $line;
    my @fields = split /\t/, $line;
    my $col6 = $fields[5];

    # 检查第六列是否已存在于fix、length或NAA
    unless (exists $existing_col6{$col6} || exists $col6_in_naa{$col6}) {
        print $naa_fh "$line\n";
        $col6_in_naa{$col6} = 1;  # 标记已在NAA中出现
    }
}
close $str_fh;

# 关闭所有文件句柄
close $fix_fh;
close $length_fh;
close $naa_fh;

