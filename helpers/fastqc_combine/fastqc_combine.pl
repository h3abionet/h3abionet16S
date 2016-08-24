#! /usr/bin/env perl
# Modified version of the illuminati source (illuminate/scripts/fastqc.pl). Can now run on FASTQC reports generated from a casava run
# e.g ~/software/illuminati/scripts/fastqc.pl -v --out fastqc_original_out --skip --files "fastqc_original_out/*fastqc"
# Where fastqc_original_out contains the generated FASTQC reports

####################
# run fastqc, create html file with links to reports
# call with -h flag for more info
####################
use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

use Getopt::Long;

my $thumbscript = "$FindBin::Bin/thumbs.sh";

my $names_file = "";
my $output_dir = ".";
my ($verbose, $help,  $skip, $auto_out) ;
my $files_pattern = "*{sequence,qseq}*.{txt,qc,fq}";
my $result = GetOptions ("name=s" => \$names_file, #string
	                     "verbose" => \$verbose, #bool
                       "skip" => \$skip, #bool
                       "auto-out" => \$auto_out, #bool
                       "out=s" => \$output_dir, #string
                       "help" => \$help,
                       "files=s" =>\$files_pattern); 
usage() if $help;

sub usage
{
   print "usage: fastqc [-v] [-h] [--skip]  [--names NAMES_FILE]\n";
	print "\n";
	print "--name  NAMES_FILE - with this option, the sample names are provided by a\n";
	print "			text file instead of the lims system.\n";  
	print "			NAMES_FILE is a tab delimited text file and should have the format:\n";
	print "			<Sample Name>\t<Adapter Sequence>\n";
	print "\n";
	print "--out   OUTPUT_DIR - specify the directory to output the qc data and reports. Defaults\n";
	print "			to the current directory.\n";
	print "\n";
	print "--skip - Do not run fastqc on the sequence data, only generate reports from a previous run\n";
	print "\n";
	print "--files FILE_PATTERN - The file pattern to run fastqc on. Defaults to *sequence / *qseq files\n";
	print "\n";
	print "-h - Print this message\n";
	print "\n";
   exit;
}


#get directory names
my $first_lane = 1;

my @samplenames = ();
my %adapter_name = ();

print "Output Dir: $output_dir\n" if $verbose;

if( $names_file )
{
	print "Getting sample names from: $names_file\n" if $verbose;
	unless(-e $names_file)
	{
		print "ERROR: name file is not valid and cannot be found.\n";
		print "name file provided: $names_file.\n";
		exit;
	} 
	open(NAMEFILE, $names_file);
	while(<NAMEFILE>) 
	{
		chomp;
		my ($sample_name, $adapter_seq) = split("\t");
		$adapter_name{ $adapter_seq } = $sample_name if ($adapter_seq && $sample_name);
	}
	close(NAMEFILE);
	while ( my ($key, $value) = each(%adapter_name) )
	{
		print "$key => $value\n" if $verbose;
	}
}

#print "Creating fastqc directory if needed\n" if $verbose;
#$output_dir = $output_dir . "/fastqc";
#`mkdir -p $output_dir`;

#run fastqc on all sequence files in dir
print "Running fastqc on $files_pattern \n" if $verbose;

unless( $skip ) #skip input flag will skip running fastqc
{
	# here we run fastqc on all files with 'sequence' in the 
	# a more complete match might be necessary.
	`fastqc $files_pattern -o $output_dir -t 8`;
}

#remove archives. 
#TODO: is this used anymore?
#`rm -f $output_dir/*fastqc.zip`;

#get names of sequence files
#my $sequence_files = `ls $files_pattern | sed "s/ \+//g"`;
my $sequence_files = `ls -d $files_pattern | sed "s/^.*\\///g"`;
print "SEQUENCE FILES: $sequence_files\n";
my @files = split("\n",$sequence_files);

print "Generating fastqc_summary.htm\n" if $verbose;

open(HTML,">$output_dir/fastqc_summary.htm");

#list col names
my @names = ("basic","base qual","tile qual","seq qual","seq cont","seq GC","base N","len dist","seq dup","over rep","adap cont","kmers");
foreach my $name (@names)
{
	$name = "<td><font size=1>$name</font></td>";
}
my $names = join("",@names);

#start printing table
print HTML "<table cellpadding=1><tr><td></td><td><font size=2>&nbsp;&nbsp;&nbsp;sample</font></td>$names</tr>\n";

my $j = $first_lane - 1;
foreach my $file (@files) #collecting the pass/warn/fail info for each lane.
{
	# This is the first component of the href written in the reports. 
	my $firstpart = $file;
	print "FIRSTPART $firstpart\n";
	# it seems that if the file ends in .txt, then it won't be included in the directory
	# name for images and such. However, if it ends in .fq the .fq will be part of the 
	# name.
	$firstpart =~ s/\.txt//g;
        $firstpart =~ s/\.gz//g;
        $firstpart =~ s/\.fastq//g;
        $firstpart =~ s/_fastqc//g;

	print "Filename is: $firstpart\n" if $verbose;

	#create thumbnails using imagemagick convert! How cool!
	my $imagedir = "$output_dir/$firstpart"."_fastqc/Images";

	# First remove thumb files from this directory if they exist
	# This prevents issues if fastqc is run multiple times
	`rm -f $imagedir/thumb.*`;

	print "ImageMagick: $thumbscript  $imagedir" . "\n";
	`$thumbscript $imagedir`;

	open(IN,"$output_dir/$firstpart"."_fastqc/summary.txt");
	my @pf = ();
	my $i=0;
	while(<IN>)
	{
		my ($passfail,$name,@junk) = split('\t',$_);
		if($passfail =~ /PASS/)
		{
			$passfail = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$i\"><img border=0 src=\"$firstpart"."_fastqc/Icons/tick.png\"></a></td>";
		}
		if($passfail =~ /WARN/)
		{
			$passfail = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$i\"><img border=0 src=\"$firstpart"."_fastqc/Icons/warning.png\"></a></td>";
		}
		if($passfail =~ /FAIL/)
		{
			$passfail = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$i\"><img border=0 src=\"$firstpart"."_fastqc/Icons/error.png\"></a></td>";
		}
		push(@pf,$passfail);
		$i++;
	}
	my $pfs = join("\t",@pf);

	# If we can extract the adapter sequence - and there is a match in our hash, use that 
	my $adapter_seq = extract_adapter_sequence($file);
	#print $adapter_seq . "\n" if $verbose; 
	my $sample_name = $adapter_name{$adapter_seq} || $samplenames[$j] || "unknown";
	#print $sample_name . "\n" if $verbose;
	
	#print the row (lane)
	print HTML "<tr><td><font size=2><a href=\"$firstpart"."_fastqc/fastqc_report.html\">$file</a></font></td><td nowrap>&nbsp;&nbsp;<font size=2>$sample_name</font>&nbsp;&nbsp;</td></td>$pfs</tr>\n";
	if($file =~ /s_\d+_1_sequence/)
	{
		print "WARNING: Not changing name for next row.\n" if $verbose;
	}
	else
	{
		print "Changing name for next row.\n" if $verbose;
		$j++;
	}
	print "\n" if $verbose;
}
print HTML "</table>";
print HTML "<br>";
print HTML "<font size=2><a href=\"http://wiki/research/FastQC/SIMRreports\">How to interpret FastQC results</a></font>"; 


#another html page with actual plots (thumbnails).

#these names are slightly different, because two of the items are text based tables, not plots. Kind of messy.

@names = ("base qual","seq qual","seq cont","tile qual","seq GC","base N","len dist","seq dup","kmers");
my @ms = (1,2,3,4,5,6,7,8,10); #skip 0 and 9, because they are text based tables
foreach my $name (@names)
{
	$name = "<td><font size=2>$name</font></td>";
}
$names = join("",@names);

my @img_files = ("per_base_quality.png","per_sequence_quality.png","per_base_sequence_content.png","per_tile_quality.png","per_sequence_gc_content.png","per_base_n_content.png","sequence_length_distribution.png","duplication_levels.png","kmer_profiles.png");

print "Generating fastqc_plots.htm\n" if $verbose;

open(HTML2,">$output_dir/fastqc_plots.htm");
print HTML2 "<table cellpadding=1><tr><td></td><td><font size=2>&nbsp;&nbsp;&nbsp;sample&nbsp;&nbsp;&nbsp;</font></td>$names</tr>\n";

$j = $first_lane - 1;
foreach my $file (@files)
{
	my $firstpart = $file;
	$firstpart =~ s/\.txt//g;
        $firstpart =~ s/\.gz//g;
        $firstpart =~ s/\.fastq//g;
        $firstpart =~ s/_fastqc//g;

	my @imgs = ();
	my $i = 0;
	foreach my $img_file (@img_files)
	{
		my $image = " "; 
		my $thumb = "$firstpart"."_fastqc/Images/thumb.".$img_file;
		if(-e "$output_dir/$thumb")
		{
			$image = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$ms[$i]\"><img border=0 src=\"$thumb\"></a></td>";
		}
		else
		{
			print "Image doesn't exist: $output_dir/$thumb\n" if $verbose;
			$image = "<td align=\"center\"><font size=1>N/A</font></td>";
		}
		push(@imgs,$image);
		$i++;
	}
	my $row = join("",@imgs);


   my $adapter_seq = extract_adapter_sequence($file);
   my $sample_name = $adapter_name{$adapter_seq} || $samplenames[$j] || "unknown";

	print "Sample Name: " . $sample_name . "\n" if $verbose;

	print HTML2 "<tr><td><font size=2><a href=\"$firstpart"."_fastqc/fastqc_report.html\">$file</a></font></td><td nowrap>&nbsp;&nbsp;<font size=2>$sample_name</font>&nbsp;&nbsp;</td></td>$row</tr>\n";

   if($file =~ /s_\d+_1_sequence/)
   {
		print "WARNING: Not changing name for next row.\n" if $verbose;
   }
   else
   {
		print "Changing name for next row.\n" if $verbose;
     	$j++;
   }

	print "\n" if $verbose;
}
print HTML2 "</table>";
print HTML2 "<br>";
#print HTML2 "<font size=2><a href=\"http://wiki/research/FastQC/SIMRreports\">How to interpret FastQC results</a></font>";

sub extract_adapter_sequence
{
	my($filename);
	$filename = $_[0];
	
	my $adapter_seq = "";
	if( $filename =~ /.*_([GTAC]+)\./ )
	{
		$adapter_seq = $1;
	}
	return $adapter_seq;
} 
