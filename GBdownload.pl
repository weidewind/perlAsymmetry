use Bio::DB::GenBank;
use Bio::DB::RefSeq;
use Bio::DB::EUtilities;
use Bio::SeqIO;

my @ids = qw(NC_000964
NC_002745
NC_002505
NC_002506
NC_000907
NC_000908
NC_003028
NC_003098
NC_000915
NC_000962
NC_003197
NC_008601
NC_005966
NC_002771
NC_008463
NC_004631
NC_007795
NC_000913
NC_000913
NC_011916
NC_009009
NC_010729
NC_004663
NC_007651
NC_007650
NC_000962
NC_016856
NC_000962
NC_009511
NC_004347
NC_002516
NC_002163
NC_016810
NC_004631
NC_016776
NC_006350
NC_006351
);
 
for my $id (@ids) { 
my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
                                       -db      => 'nucleotide',
                                       -rettype => 'gbwithparts',
                                       -email   => 'mymail@foo.bar',
                                       -id      => $id);
 
my $file = 'genb.gb';
 
# dump HTTP::Response content to a file (not retained in memory)
$factory->get_Response(-file => $file, -format => 'gb');
 

my $seqio_object = Bio::SeqIO->new(-file => '/cygdrive/c/Users/weidewind/Documents/Asymmetry/2015/CompleteGenomes/genb.gb', -format => 'genbank' );       
my $seq_object = $seqio_object->next_seq; 
my $name =  $seq_object->species->binomial();
$name = $name."_".($seq_object->display_id);
$name =~ s/\s+/_/g;


open OUT, ">$name";


for my $feat_object ($seq_object->get_SeqFeatures) { 
	       
  # push @ids, $feat_object->get_tag_values("db_xref") if ($feat_object->has_tag("db_xref")); 
      
   if ($feat_object->primary_tag eq "CDS") {
   	 
   	       if ($feat_object->has_tag('locus_tag')) {
      	print OUT $feat_object->get_tag_values('locus_tag'),"\t";
      }
      else {
      	print OUT "nolocustag\t";
      }
      my $found_gi = 0;
       if ($feat_object->has_tag('db_xref')) {
      	for my $val ($feat_object->get_tag_values('db_xref')){
      		if (substr($val, 0, 3) eq "GI:"){
      			print OUT $val,"\t";
      			$found_gi = 1;
      		}

         }
      }
     if ($found_gi == 0) {
      	print OUT "NOID\t";
      }
      
      
     if ($feat_object->has_tag('gene')) {
         for my $val ($feat_object->get_tag_values('gene')){
            print OUT $val,",";
            # e.g. 'NDP', from a line like '/gene="NDP"'
         }
      }
      else {
      	 print OUT "ND";
      }
      print OUT $val,"\t";
   	  print OUT $feat_object->start,"\t";
   	  print OUT $feat_object->end,"\t";
   	  print OUT $feat_object->strand;
    #  print OUT $feat_object->spliced_seq->seq,"\n";
      # e.g. 'ATTATTTTCGCTCGCTTCTCGCGCTTTTTGAGATAAGGTCGCGT...'



      	print OUT "\n";

   }
   
}
}