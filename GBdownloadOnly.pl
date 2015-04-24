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
 
my $file = $id.".gb";
 
# dump HTTP::Response content to a file (not retained in memory)
$factory->get_Response(-file => $file, -format => 'gb');
}