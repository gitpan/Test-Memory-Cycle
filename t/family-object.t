# $Id: family-object.t,v 1.1 2004/01/20 04:53:46 andy Exp $
use strict;
use warnings FATAL => 'all';

use Test::More tests => 2;
use Test::Builder::Tester;
use Getopt::Long;

BEGIN {
    use_ok( 'Test::Memory::Cycle' );
}

my $dis = Getopt::Long::Parser->new;
my $dat = Getopt::Long::Parser->new;

$dis->{dose} = [$dat,$dat,$dat];
$dat->{dem} = { dis => $dis };

test_out( "not ok 1 - Object family" );
test_fail( +16 );
test_diag( 'Cycle #1' );
test_diag( '    Getopt::Long::Parser A->{dose} => @B' );
test_diag( '    @B->[0] => Getopt::Long::Parser C' );
test_diag( '    Getopt::Long::Parser C->{dem} => %D' );
test_diag( '    %D->{dis} => Getopt::Long::Parser A' );
test_diag( 'Cycle #2' );
test_diag( '    Getopt::Long::Parser A->{dose} => @B' );
test_diag( '    @B->[1] => Getopt::Long::Parser C' );
test_diag( '    Getopt::Long::Parser C->{dem} => %D' );
test_diag( '    %D->{dis} => Getopt::Long::Parser A' );
test_diag( 'Cycle #3' );
test_diag( '    Getopt::Long::Parser A->{dose} => @B' );
test_diag( '    @B->[2] => Getopt::Long::Parser C' );
test_diag( '    Getopt::Long::Parser C->{dem} => %D' );
test_diag( '    %D->{dis} => Getopt::Long::Parser A' );
memory_cycle_ok( $dis, "Object family" );
test_test( "Object family testing" );
