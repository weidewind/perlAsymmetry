 #!/usr/bin/perl
use Bio::SeqIO;
 use Bio::Tools::CodonOptTable;

 my $seqobj = Bio::Tools::CodonOptTable->new ( -seq => 'ATGGGGTGGGCACCATGCTGCTGTCGTGAATTTGGGCACGATGGTGTACGTGCTCGTAGCTAGGGTGGGTGGTTTG',
                                                -id  => 'GeneFragment-12',
                                                -accession_number => 'Myseq1',
                                                -alphabet => 'dna',
                                                -is_circular => 1,
                                                -genetic_code => 1,
                                   );

    B<#If you wanna read from file>
    my $seqobj = Bio::Tools::CodonOptTable->new(-file => "contig.fasta",
                                             -format => 'Fasta',
                                             -genetic_code => 1,
                                             );

    B<#If you have Accession number and want to get file from NCBI>
    my $seqobj = Bio::Tools::CodonOptTable->new(-ncbi_id => "J00522",
                                                -genetic_code => 1,);

    my $myCodons = $seqobj->rscu_rac_table();
    
    if($myCodons)
    {
        for my $each_aa (@$myCodons)
        {
            print "Codon      : ",$each_aa->{'codon'},"\t";
            print "Frequency  : ",$each_aa->{'frequency'},"\t";
            print "AminoAcid  : ",$each_aa->{'aa_name'},"\t";
            print "RSCU Value : ",$each_aa->{'rscu'},"\t"; #Relative Synonymous Codons Uses
            print "RAC Value  : ",$each_aa->{'rac'},"\t"; #Relative Adaptiveness of a Codon
            print "\n";
        }
    }
    
    B<# To get the prefered codon list based on RSCU & RAC Values >
    my $prefered_codons = $seqobj->prefered_codon($myCodons);

    while ( my ($amino_acid, $codon) = each(%$prefered_codons) ) {
        print "AminoAcid : $amino_acid \t Codon : $codon\n";
    }
    
    B<# To produce a graph between RSCU & RAC>
    # Graph output file extension should be GIF, we support GIF only
    
    $seqobj->generate_graph($myCodons,"myoutput.gif");

    B<# To Calculate Codon Adaptation Index (CAI)>
  
    my $gene_cai = $seqobj->calculate_cai($myCodons);
    
    
    

 my $seqio_object = Bio::SeqIO->new(-file => "/cygdrive/c/Users/weidewind/Documents/Asymmetry/2015/CompleteGenomes/Sent_SL1344_complete.gb" );       
my $seq_object = $seqio_object->next_seq;

open OUT, ">Psae_PAO1";

for my $feat_object ($seq_object->get_SeqFeatures) { 
	       
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