#!/usr/bin/perl
use strict;
use warnings;

# Ensure proper command line arguments
if (@ARGV != 4) {
    die "Usage: $0 pair_point.txt str.bed output_file.txt ref_genome\n";
}

# Input files and output file from command line arguments
my ($pair_file, $str_file, $output_file, $ref_genome) = @ARGV;
my $fasta_file = "$output_file.fasta";

# Open input files and handle errors if any
open my $IN,  '<', $pair_file   or die "Could not open '$pair_file': $!";
open my $UP,  '<', $str_file    or die "Could not open '$str_file': $!";
open my $OUT, '>', $output_file or die "Could not open '$output_file': $!";
open my $OUT1, '>', $fasta_file or die "Could not open '$fasta_file': $!";

# Variables to store data
my %hash;
my %seq;
my $i = 0;

# Split the filename using '_', and handle cases where '_' might not exist
my @name = split /_/, $pair_file;

# Check if the array has at least 2 elements to prevent uninitialized value errors
my $name_part = $name[2] // '';  # Use empty string if $name[1] is undefined

# Process pair_point.txt
while (<$IN>) {
    chomp;
    s/Chr/chr/g;  # Replace 'Chr' with 'chr'
    $i++;
    my @a = split /\t/;

    # Check if the filename contains the reference genome
    if ($name_part =~ /$ref_genome/) {
        my $ref_pos = "$a[2]\t$a[3]";
        $hash{$ref_pos} = $i;
        $seq{$i} = $a[7];
    } else {
        my $ref_pos = "$a[0]\t$a[1]";
        $hash{$ref_pos} = $i;
        $seq{$i} = $a[8];
    }
}
close $IN;

# Process str.bed
while (<$UP>) {
    chomp;
    my @b = split /\t/;
    my $s1 = $b[1] - 20;  # Start position minus 20
    my $e1 = $b[2] + 20;  # End position plus 20

    print $OUT join("\t", @b), "\t";  # Output original line with extra tab
    print $OUT1 ">$b[0]_$b[1]_$b[2]\n";  # Write to FASTA

    my $start = "$b[0]\t$s1";
    my $end = "$b[0]\t$e1";

    # Print sequences between $start and $end
    if (exists $hash{$start} && exists $hash{$end}) {
        for my $n ($hash{$start}..$hash{$end}) {
            print $OUT "$seq{$n}";

            # Avoid writing sequences with '-'
            if ($seq{$n} =~ /-/) {
                next;
            } else {
                print $OUT1 "$seq{$n}";
            }
        }
    }
    
    print $OUT "\n";  # Add newline after each entry
    print $OUT1 "\n";  # Add newline after each entry
}
close $UP;
close $OUT;
close $OUT1;

print "Processing complete. Results are written to '$output_file' and '$fasta_file'.\n";
