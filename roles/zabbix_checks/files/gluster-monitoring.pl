#!/usr/bin/perl

use strict;
use Switch;

# --------- base config -------------
#$ENV{'HEKETI_CLI_SERVER'} = 'http://10.2.0.73:8081';
# ----------------------------------

switch ($ARGV[0])
{
case "discovery" {
my $first = 1;

print "{\n";
print "\t\"data\":[\n\n";


my $result = `gluster volume list`;

my @lines = split /\n/, $result;
foreach my $l (@lines) {
        my @stat = split / +/, $l;

                print ",\n" if not $first;
                $first = 0;

                print "\t{\n";
                print "\t\t\"{#NAME}\":\"$stat[0]\"\n";
                print "\t}";
}

print "\n\t]\n";
print "}\n";
}

case "peers-discovery" {
my $first = 1;

print "{\n";
print "\t\"data\":[\n\n";


my $result = `gluster pool list | tail -n +2`;

my @lines = split /\n/, $result;
foreach my $l (@lines) {
        my @stat = split /\s+/, $l;

                print ",\n" if not $first;
                $first = 0;

                print "\t{\n";
                print "\t\t\"{#UUID}\":\"$stat[0]\",\n";
                print "\t\t\"{#HOSTNAME}\":\"$stat[1]\",\n";
                print "\t\t\"{#STATE}\":\"$stat[2]\"\n";
                print "\t}";
}

print "\n\t]\n";
print "}\n";
}

case "status" {
my $result = `gluster volume status $ARGV[1] detail --xml`;
        
    print $result;

}

case "info" {
my $result = `gluster volume info $ARGV[1] --xml`;
        
    print $result;

}

case "peers-status" {
my $result = `gluster peer status --xml`;
        
    print $result;

}

}

