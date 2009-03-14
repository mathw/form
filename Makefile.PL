#!/usr/bin/perl
$|++;

use strict;
use warnings;

use File::Spec;

my $rakudo_dir = $ENV{RAKUDO_DIR};
my $parrot_dir = $ENV{PARROT_DIR};
my $rakudo;

$rakudo_dir or $parrot_dir or die 'Please set $RAKUDO_DIR or $PARROT_DIR (see README).'."\n";

$ENV{PERL6LIB} or die 'Please set $PERL6LIB (see README).'."\n";

if ( ! $rakudo_dir ) {
	# we have to assume rakudo-inside-parrot
	# and synthesise a rakudo_dir from that
	# We know we have parrot_dir if we got this far
	
	if ( ! -d $parrot_dir ) {
		die <<EOT;
Not a directory $parrot_dir, no \$RAKUDO_DIR provided.
Please set \$RAKUDO_DIR or \$PARROT_DIR correctly (see README).
EOT
	}

	$rakudo_dir = File::Spec->catfile($parrot_dir, 'languages', 'rakudo');
}

if ( $rakudo_dir ) {
	if ( ! -d $rakudo_dir ) {
		die <<EOT
Not a directory $rakudo_dir.
Please set \$RAKUDO_DIR or \$PARROT_DIR correctly (see README).
EOT
	}
	else {
		if ( ! $parrot_dir ) {
			# parrot-inside-rakudo
			$parrot_dir = File::Spec->catfile($rakudo_dir, 'parrot');
		}

		$rakudo = File::Spec->catfile($rakudo_dir, 'perl6');
		if ( ! -x $rakudo ) {
			# try 'parrot perl6.pbc'
			my $parrot = File::Spec->catfile($parrot_dir, 'parrot');
			if ( ! -x $parrot ) {
				# that's it, no more options
				die <<EOT
Not an executable $rakudo
Not an executable $parrot
Please set \$RAKUDO_DIR or \$PARROT_DIR correctly.
Please ensure you have built Rakudo in those locations.
See README for further information.
EOT
			}
			
			my $rakudo_pbc = File::Spec->catfile($rakudo_dir, 'perl6.pbc');
			if ( ! -f $rakudo_pbc ) {
die <<EOT
Not an executable $rakudo
File not found $rakudo_pbc
Please set \$RAKUDO_DIR or \$PARROT_DIR correctly.
Please ensure you have built Rakudo in those locations.
See README for further information.
EOT
			}
			$rakudo = "$parrot $rakudo_pbc";
		}
	}
}

print <<EOT;
Using Rakudo: $rakudo
RAKUDO_DIR: $rakudo_dir
PARROT_DIR: $parrot_dir
EOT

my @infiles = map { $_.'.in' } qw< Makefile >;

my %replacements = (
    PARROT_DIR => $parrot_dir,
	RAKUDO_DIR => $rakudo_dir,
	RAKUDO     => $rakudo
);

if ( !-e 'lib/Test.pm' ) {
	# Note: bad: this won't work on Windows
	# Maybe we should be ensuring $rakudo_dir is in PERL6LIB?
    !system("ln -s $rakudo_dir/Test.pm lib/") or die @!;
    print "Symlinked Test.pm from the Rakudo directory \n";
}

for my $infile (@infiles) {
    if ((my $outfile = $infile) =~ s/\.in$//g) {
        open my $IN,  '<', $infile  or die "Couldn't open $infile, $!, $?";
        open my $OUT, '>', $outfile or die "Couldn't open $outfile, $!, $?";
        while (my $line = <$IN>) {
            while ( $line =~ /<(.*?)>/g ) {
                my $repl = $1;
                if (exists $replacements{$repl}) {
                    $line =~ s/<$repl>/$replacements{$repl}/g;
                }
            }
            print $OUT $line;
        }
        print "Created $outfile \n";
    }
}

