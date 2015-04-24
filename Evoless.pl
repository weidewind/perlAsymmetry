    use DBI;


evoless("phylum");
#evoless("class");
#evoless("order");
#evoless("family");

sub evoless{
	
	my $rank = $_[0]; #phylum, or class, or order
	
my @names = (
#"Haemophilus influenzae Rd KW20",
#"Mycoplasma genitalium G37",
#"Escherichia coli str. K-12 substr. MG1655",
#"Helicobacter pylori 26695",
#"Mycobacterium tuberculosis H37Rv",
#"Bacillus subtilis subsp. subtilis str. 168",
#"Campylobacter jejuni subsp. jejuni NCTC 11168",
#"Vibrio cholerae O1 biovar El Tor str. N16961",
#"Pseudomonas aeruginosa PAO1",
#"Staphylococcus aureus subsp. aureus N315",
#"Mycoplasma pulmonis UAB CTIP",
#"Streptococcus pneumoniae R6",
#"Salmonella enterica subsp. enterica serovar Typhimurium str. LT2",
#"Shewanella oneidensis MR-1",
#"Salmonella enterica subsp. enterica serovar Typhi str. CT18",
#"Salmonella enterica subsp. enterica serovar Typhi str. Ty2",
#"Bacteroides thetaiotaomicron VPI-5482",
#"Acinetobacter sp. ADP1",
#"Burkholderia pseudomallei K96243",
#"Burkholderia thailandensis E264",
#"Staphylococcus aureus subsp. aureus NCTC 8325",
#"Pseudomonas aeruginosa UCBPP-PA14",
#"Francisella novicida U112",
#"Streptococcus sanguinis",
#"Sphingomonas wittichii RW1",
#"Porphyromonas gingivalis ATCC 33277", #to strat with
#"Caulobacter crescentus NA1000",
#"Streptococcus pneumoniae TIGR4",
#"Bacteroides fragilis 638R",
"Bacteroides fragilis NCTC 9343"
#"Salmonella enterica serovar Typhimurium SL1344",
#"Salmonella enterica subsp. enterica serovar Typhimurium str. 14028S"
);

#@names=("Haemophilus influenzae Rd KW20");

for my $name (@names) { 
	my $tname = $name;
	$tname =~ s/\s+/_/g;
open OUT, (">Evoless_".$rank."_".$tname) or die;
my $dbh = DBI->connect('dbi:mysql:taxonomy_ncbi','root','lotus34') or die "Connection Error: $DBI::errstr\n";
	
    	my $sql = "select taxid from species where species like '".$name."%'";
    	my $sth = $dbh->prepare($sql);
    	$sth->execute or die "SQL Error: $DBI::errstr\n";
    	if (my @row = $sth->fetchrow_array){
    		print "my taxid ".$row[0]."\n";   # that is the taxid of our bacterium
    		my $higher = find_higher_taxon($row[0], $rank, $dbh);   # that is the desired phylum (or class) 
			print $rank." taxid ".$higher."\n"; 
			my $sql = "select nog from bactnog where taxid=".$row[0];
    		my $sth = $dbh->prepare($sql);
    		$sth->execute or die "SQL Error: $DBI::errstr\n";
    		
    		my %nogs;
    		while(my @t = $sth->fetchrow_array){
    			$nogs{$t[0]}=1;
    		}
   			my @unique_nogs = keys %nogs;
    			print scalar(@unique_nogs)."\n";
    			foreach(@unique_nogs){
    				print OUT $_."\t";
    				my $sql = "select taxid from bactnog where nog='".$_."'";
    				my $sth = $dbh->prepare($sql);
    				$sth->execute or die "SQL Error: $DBI::errstr\n";
    				
    				my %taxids;
    				while(my @t = $sth->fetchrow_array){
    					$taxids{$t[0]} = 1;
    				}
    				
    					my $counter = 0;
    					my @unique_taxids = keys %taxids;
    					foreach(@unique_taxids){
    						if ($higher eq find_higher_taxon($_, $rank, $dbh)){
    							$counter++;
    						}
    					}
    					print OUT $counter."\t";
    					
    				
    				my $sql = "select locus from bactnog where nog='".$_."' and taxid=$row[0]";
    				my $sth = $dbh->prepare($sql);
    				$sth->execute or die "SQL Error: $DBI::errstr\n";
    				if (my @locus = $sth->fetchrow_array){
    					print OUT $locus[0]."\n";
    				}
    		}
    		
    		
    	}
    	
    	else {
    		print  "didn't find $name\n";
    	}
    	close OUT;
}   	
}

sub find_higher_taxon{
	my $taxid = $_[0]; # e.g., 392499. must be species
	my $rank = $_[1]; #e.g., "phylum"
	my $dbh = $_[2]; # db connection
	
	my $sql = "select rank, parent_taxid from nodes where taxid=$taxid";
    my $sth = $dbh->prepare($sql);
    $sth->execute or die "SQL Error: $DBI::errstr\n";
    if (my @row = $sth->fetchrow_array){
    	if ($row[0] eq $rank){
    		return $taxid;
    	}	
    	else {
    		find_higher_taxon($row[1], $rank, $dbh)
    	}
    }
	
}

#my $dbh = DBI->connect('dbi:mysql:taxonomy_ncbi','root','lotus34') or die "Connection Error: $DBI::errstr\n";
#print find_higher_taxon(392499, "phylum", $dbh);