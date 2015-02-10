#!C:\strawberry\perl\bin
#    Filename: sort_list_of_tlds.pl
#      Author: Hillary Parham
# Description: This script generates a list of Top Level Domains from a csv file dump of the url history

use strict;
use Text::CSV;
use URI::URL;

my $csv_file = "D:\\Users\\Hillary\\Documents\\url_history.csv";  # CSV file
my $csv = Text::CSV->new( {binary => 1} ) or die "Cannot use CSV"; # create an instance Text::CSV a cpan module

open my $fh, $csv_file or die "couldn't open csv file"; # open the CSV file

my %url_hash = (); # hash so that I can get unique tlds from the chrome history

# Loop through the rows of data in the csv file
while( my $row = $csv->getline($fh) ){
    my $url = new URI::URL $row->[1];   # create an instance of URI::URL a cpan module
	# incrementing a counter on each element of the hash doing this so that I have a list of unique domain
	# names from the url history file
    $url_hash{$url->netloc} = $url_hash{$url->netloc} + 1;  
}    
close $fh;   # done with the file so close it

# open a file to write te output to
open my $fh_out, ">D:\\Users\\Hillary\\Documents\\tld_file.txt" or die "couldn't open output file";
my $count = 0;  # set counter to zero

# loop through each key of the url hash
foreach my $key ( keys %url_hash ) {
    # if you don't already have 50 domains in your file and the key is not blank then print the
	# hash key to your file and increment your counter by 1;
    if($count < 50 and $key ne ""){
        print $fh_out "$key\n";
		$count++;
	}
}
#close your file
close $fh_out;
#exit script
exit(0);