# $Id: family-hash.t,v 1.1 2004/01/20 04:53:46 andy Exp $
use strict;
use warnings FATAL => 'all';

use Test::More tests => 2;
use Test::Builder::Tester;

BEGIN {
    use_ok( 'Test::Memory::Cycle' );
}

my $mom = {
    name => "Marilyn Lester",
};

my $me = {
    name => "Andy Lester",
    mother => $mom,
};
$mom->{son} = $me;

test_out( "not ok 1 - Small family" );
test_fail( +4 );
test_diag( 'Cycle #1' );
test_diag( '    %A->{mother} => %B' );
test_diag( '    %B->{son} => %A' );
memory_cycle_ok( $me, "Small family" );
test_test( "Small family testing" );
