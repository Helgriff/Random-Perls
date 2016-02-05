#!/usr/bin/perl
use strict;
use warnings;

# Find the following motifs in DNA sequence files

# define variables
my @motifs =("CC.CC.T..CC.C","CC.CC.T..CC.CC","CC.C..T...C.T..C","CC.C...C.T..CC.C","C...CC.T..CC.C","CC.C..T...C.T..C","CC.C..T...C.T..C","C..C.........CC.C","CC.C..T...C.T..C","CC.CC.T..C",".C..T...C.T..CC.C");
my $DNA = "/path/to/fasta/file.fasta";
my @c; #array variable to store DNA sequence
my $output = "/path/to/output/results.txt";
my $Bigsequence="";
my $header="";

# write output to results.txt
open OUT, ">$output" or die "CANNOT OPEN OUTPUT FILE";
print OUT "SEARCH_SEQ_NAME\tMOTIF_NO\.\tMOTIF\tSTART_POSITION_DNA\tMOTIF_SEQUENCE\n";

# open the input file
open IN, $DNA or die "CANNOT OPEN $DNA";
# loop to create one line of DNA sequence from the input file
loop: while (<IN>){
                my $line =$_;
                chomp $line;
                if($line=~/\>/ and $Bigsequence!~/[ACGTN]/){$header=$line; next loop;}
                if($line=~/\>/ and $Bigsequence=~/[ACGTN]/){find_motif($Bigsequence); $header=$line; $Bigsequence=""; next loop;}
                $Bigsequence = $Bigsequence.$line;
        } 
        close(IN);

        find_motif($Bigsequence); #run subroutine on final sequence in fasta file
        close(OUT);

## Subroutine ###
sub find_motif{
my($Bigsequence) = @_;
# loop to look for each motif
for (my $mc=0; $mc<scalar(@motifs); $mc++){
        my $motif = $motifs[$mc];
        my $mlength = length($motif);
        # search the big sequence string for the motif
        if($Bigsequence =~/$motif/){
                @c = split ("", $Bigsequence);
                # loop to count the motif match and place in scalar array @c
                for (my $count1 = 0; $count1 <= ((scalar @c)-$mlength); $count1++){
                        my $tempseq = ""; #place the counted sequences in a my variable
                        for (my $count2 = 0; $count2<$mlength; $count2++){
                                my $final_count = $count1 + $count2;
                                $tempseq= $tempseq.$c[$final_count];
                        }
        # new loop to search the extracted split sequence for the motif 
        if ($tempseq =~/$motif/){
        my $print_count = $count1+1; #must add 1 as the array count starts from 0 but DNA base starts from 1
        my $motifNUM = $mc + 1;
        print OUT "$header\t$motifNUM\t$motifs[$mc]\t$print_count\t$tempseq\n";
              } #end if tempseq match motif
            } #end for $count1
        } #end if bigseq match motif
} #end for motif loop
#return;

$Bigsequence=""; #re-inititalise bigsequence
}

exit;
