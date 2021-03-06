 #!/usr/bin/perl
use Bio::SeqIO;
 use Bio::Tools::CodonOptTable;

my $seqio_object = Bio::SeqIO->new(-file => "/cygdrive/c/Users/weidewind/Documents/Asymmetry/2015/CompleteGenomes/Sent_SL1344_complete.gb" );       
my $seq_object = $seqio_object->next_seq;

open OUT, ">Psae_PAO1";
my $ori_start = 6264361;
my $ori_stop = 482;
my $ter = 2428794;
my $ori_padding = 2000;
my $ter_padding = 2000;



for my $feat_object ($seq_object->get_SeqFeatures) { 
	       
  # push @ids, $feat_object->get_tag_values("db_xref") if ($feat_object->has_tag("db_xref")); 
      
   if ($feat_object->primary_tag eq "CDS") {
   	 
   	       if ($feat_object->has_tag('locus_tag')) {
      	print OUT $feat_object->get_tag_values('locus_tag'),"\t";
      	print $feat_object->seq()->seq;
      		print "\n";

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