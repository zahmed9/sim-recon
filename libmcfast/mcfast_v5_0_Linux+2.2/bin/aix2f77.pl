#!/usr/local/bin/perl
# This is a hack of vms2f90
# Original ksh script by   T. Wenaus  LLNL
# Perl script by           L. Garren  FNAL
# Convert VMS structures to Fortran 77 structures.
# Operates on files of type .f (cpp has already been run).


$fname = @ARGV[0];
$froot = $fname;
$froot =~ s/\.f$//;
$outfile = $froot.".f90";

print "aix2f77: Converting $froot.f\n";

open(IN,$fname) || die "cannot open $fname";
open(OUT,"> $outfile") || die "cannot open $outfile";
while ($line = <IN>) {
   chop($line);
## find and fix lines with no content (rogue control characters)
   if( $line =~ /\w/ || $line =~ /\s/ ) {
   } else {
      $line = "";
   }
## if not a comment or cpp directive, look for variables to convert
## also ignore format statements
   if( $line =~ /^c/i || $line =~ /^d/i || $line =~ /^\#/ || $line =~ /^\s*$/
       || $line =~ /^\*/ || $line =~ /^\!/ || $line =~ /^\s*\!/ 
       || $line =~ /\d+\s+format/i ) {
   } else {
       if( $line =~ /^\s*record/i && $line =~ /\// ) {	#check for records
           $line =~ s/^\s*record/      type/i;
           $line =~ s/^(\s*type\s*)\/(\s*\w+\s*)\//\1\(\2\)/;	# replace slashes
       }
       if( $line =~ /^\s*structure/i && $line =~ /\// ) {	#check for structures
           $line =~ s/^\s*structure/      type/i;
           $line =~ s/^(\s*type\s*)\/(\s*\w+\s*)\//\1 \2 /;	# replace slashes
           $line = $line."\n        sequence";
       }
       if( $line =~ /end\s*structure/i ) {	#check for end structure line
           $line =~ s/\sstructure/ type/i;
       }
       if( $line =~ /\.\w/ ) { 	# dot in middle of word
           # ignore line if dot is after exclamation point
           if( index($line,".") < index($line,"!") || index($line,"!") < 0 ) {
               &parse_dots;
           }
       }
   }
   print OUT "$line\n";
}
close(IN);
close(OUT);
exit;

sub parse_dots {
    $sline = $line;
    if( $line =~ /^(.*)\!/ ) { $sline = $1; }		# remove comments
    if( $sline =~ /^(.*)\"(.*)\"(.*)\"(.*)\"(.*)$/ ) {	# look for double pairs
        @wl = ( $1, $3, $5 );	# ignore words within quotes 
        foreach $w1 ( @wl ) {
            if( $w1 =~ /\./ ) {
        	@words = split(/\s+|,|=|\+|-|\(|\)|\*|\//,$w1);	# split by whitespace , = + -
        	&parse_word;
            }
        }
    } elsif( $sline =~ /^(.*)\"(.*)\"(.*)$/ ) {		# split paired quotes
        @wl = ( $1, $3 );	# ignore word within quotes 
        foreach $w1 ( @wl ) {
            if( $w1 =~ /\./ ) {
        	@words = split(/\s+|,|=|\+|-|\(|\)|\*|\//,$w1);	# split by whitespace , = + -
        	&parse_word;
            }
        }
    } elsif( $sline =~ /^(.*)\'(.*)\'(.*)\'(.*)\'(.*)$/ ) {	# look for double pairs
        @wl = ( $1, $3, $5 );	# ignore words within quotes 
        foreach $w1 ( @wl ) {
            if( $w1 =~ /\./ ) {
        	@words = split(/\s+|,|=|\+|-|\(|\)|\*|\//,$w1);	# split by whitespace , = + -
        	&parse_word;
            }
        }
    } elsif( $sline =~ /^(.*)\'(.*)\'(.*)$/ ) {	# split paired quotes
        @wl = ( $1, $3 );	# ignore word within quotes 
        foreach $w1 ( @wl ) {
            if( $w1 =~ /\./ ) {
        	@words = split(/\s+|,|=|\+|-|\(|\)|\*|\//,$w1);	# split by whitespace , = + -
        	&parse_word;
            }
        }
    } else {
        @words = split(/\s+|,|=|\+|-|\(|\)|\*|\//,$sline);	# split by whitespace , = + -
       	&parse_word;
    }
}

sub parse_word {
    foreach $word1 ( @words ) {
        ##print "checking $word1\n";
        if( $word1 =~ /\./ ) {		# check each "word"
            &remove_operands;		# check for operators
            foreach $word ( @wlist ) {
                if( $word =~ /\./ ) {		# check each "word"
                    ##print "checking $word\n";
        	    if( $word =~ /^\d+\.\d+/ ) {	# check for numbers
        	    } elsif( $word =~ /^\.\d+/ ) {	
        	    } elsif( $word =~ /^\d+\.$/ ) {	
        	    } elsif( $word =~ /^\d+\.e/i ) {	
        	    } elsif( $word =~ /^\d+\.d/i ) {	
        	    } elsif( $word =~ /f\d+\.\d/i ) {	
        	    } elsif( $word =~ /g\d+\.\d/i ) {	
        	    } else {
                	$old_word = $word;
                	$old_word =~ s/\./\\\./g;
                	$new_word = $word;
                	$new_word =~ s/\./\%/g;
                	##print "replacing $old_word with $new_word in $line\n";
                	$line =~ s/$old_word/$new_word/;
        	    }
        	    }
            }
        }
    }
}

sub remove_operands {
    $word1 =~ s/\.and\./\.REMOVE\./ig;
    $word1 =~ s/\.or\./\.REMOVE\./ig;
    $word1 =~ s/\.gt\./\.REMOVE\./ig;
    $word1 =~ s/\.lt\./\.REMOVE\./ig;
    $word1 =~ s/\.ge\./\.REMOVE\./ig;
    $word1 =~ s/\.le\./\.REMOVE\./ig;
    $word1 =~ s/\.eq\./\.REMOVE\./ig;
    $word1 =~ s/\.ne\./\.REMOVE\./ig;
    $word1 =~ s/\.xor\./\.REMOVE\./ig;
    $word1 =~ s/\.not\./\.REMOVE\./ig;
    $word1 =~ s/\.true\./\.REMOVE\./ig;
    $word1 =~ s/\.false\./\.REMOVE\./ig;
    @wlist = split(/\.REMOVE\./,$word1);
}
