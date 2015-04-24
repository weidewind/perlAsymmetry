
 use LWP::Simple;



open OUT, ">>bafrnctc";
my $k;
while($k <3600) {
my $data = get("http://www.pathogenomics.sfu.ca/ortholugedb/ortholog_cluster?analysis_id=2187376&cluster_id=".$k);
$data =~/<td>(BF[0-9a-zA_Z]+)<\/td>/;
print OUT $1."\t";
$data =~/<td>(BF638R_[0-9a-zA_Z]+)<\/td>/;
print OUT $1."\n";
$k++;
}
close OUT;