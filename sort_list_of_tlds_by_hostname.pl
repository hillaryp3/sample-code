#!C:\strawberry\perl\bin
#    Filename: sort_list_of_tlds_by_hostname.pl
#      Author: Hillary Parham
# Description: This script reads in a text file that contains a list of domains and
#              creates a new text file that contains a sorted list of the domains read
#              in from the input file. The sort is first done by top level domain (.com, .net, .org etc).
#              It then sorts by host (google, msn, yahoo etc).
#              The sort then takes the subdomain and sorts them alphabetically.

use strict;
use Net::Domain::Regex;

# open input file
open FILE, "D:\\Users\\Hillary\\Documents\\tld_file.txt" or die "couldn't open input file";

# create an instace of the Net::Domain::Regex cpan module which use an OO interface
# this cpan module parses the parts of a domain
my $domain = Net::Domain::Regex->new();

# hash declared to be used to sort the domains
my %tld_to_sort = ();

# process the lines of the file
while ( my $value = <FILE>) {
    chomp $value;  # remove the \n at the end of the line
	# if the line matches a tld then store the full domain in a hash of hashes to make sorting easy
    # otherwise print a message to STDERR
	if (my @parts = $domain->match($value)) {
		$tld_to_sort{$parts[0]->{tld}}{$parts[0]->{domain}}{$parts[0]->{hostname}} = $parts[0]->{match};
	} else {
	    print STDERR "$value is not a match of the list of top level domains";
	}
}
# close input file
close FILE;

# open the output file
open FILE, ">D:\\Users\\Hillary\\Documents\\sorted_tld_file_hostname.txt" or die "couldn't open output file";
# sort the tld portion of the domain
foreach my $tld_key (sort keys %tld_to_sort){
    # sort the host portion of the domain
    foreach my $host_key (sort keys %{$tld_to_sort{$tld_key}}) {
	    # sort the subdomain portion of the domain
		foreach my $sub_domain_key (sort keys %{$tld_to_sort{$tld_key}{$host_key}}) {
		    # print the sorted line to the file
			print FILE "$tld_to_sort{$tld_key}{$host_key}{$sub_domain_key}\n";
		}
	}
}

close FILE;
exit(0);