#!/usr/bin/perl

use strict;
use warnings;

my $cwl_dir = "$ENV{'HOME'}/h3abionet16S/workflows";
my $docker_cwl_dir = "$ENV{'HOME'}/h3abionet16S/workflows.docker";
my $tests_file = "$docker_cwl_dir/tests";
my $docker_tests_file = "$docker_cwl_dir/tests.docker";

my @tests = &ReadTests($tests_file);
my $num_tests = @tests;
#print "@tests\n";
my @docker_tests = &ReadTests($docker_tests_file);
my $num_docker_tests = @docker_tests;
#print "@docker_tests\n";
if ($num_tests != $num_docker_tests) {
    die "number of tests and number of docker tests are different\n";
}


{
    my $test;
    my $testname;
    my $testout;
    my $cmd;
    my $out;

    foreach my $i (0 .. $num_tests-1) {
        $test = $tests[$i];
        ($testname) = $test =~ /^(.*)\.cwl/;
        $testout = "testout.$testname";
        chdir($cwl_dir);
        $cmd = "cwltool $test";
        print "Running plain CWL:\n";
        print "$cmd\n";
        $out = `$cmd 2>&1`;
        &WriteOut($testout, $out);
        print $out;
        print "\n";

        $test = $docker_tests[$i];
        ($testname) = $test =~ /^(.*)\.cwl/;
        $testout = "testout.$testname";
        chdir($docker_cwl_dir);
        $cmd = "cwltool $test";
        print "Running docker CWL:\n";
        print "$cmd\n";
        $out = `$cmd 2>&1`;
        &WriteOut($testout, $out);
        print $out;
        print "\n";
    }
}





sub ReadTests {
    my($tests_file) = @_;

    open(my $fh, "<", $tests_file) or die "Can't open < $tests_file: $!\n";

    my @tests = ();

    while (<$fh>) {
        chomp;
        next if /^$/;
        next if /^#/;
        push(@tests, $_);
    }
    close($fh);

    return @tests;
}


sub WriteOut {
    my($testout, $out) = @_;

    open(my $fh, ">", $testout) or die "Can't open > $testout: $!\n";
    print $fh $out;
    close($fh);
}
