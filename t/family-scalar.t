# $Id: family-scalar.t,v 1.1 2004/01/20 04:53:46 andy Exp $
use strict;
use warnings FATAL => 'all';

use Test::More tests => 5;
use Test::Builder::Tester;

BEGIN {
    use_ok( 'Test::Memory::Cycle' );
}

my $me;
$me = \$me;

test_out( "not ok 1 - Scalar Family" ); 
test_fail( +3 );
test_diag( 'Cycle #1' );
test_diag( '    $A => $A' );
memory_cycle_ok( $me, "Scalar Family" );
test_test( "Simple loopback" );

my $myself = \$me;
$me = \$myself;

test_out( "not ok 1" );
test_fail( +4 );
test_diag( 'Cycle #1' );
test_diag( '    $A => $B' );
test_diag( '    $B => $A' );
memory_cycle_ok( $myself ); # Test non-comments
test_test( "Simple loopback to myself" );

# Order matters
test_out( "not ok 1" );
test_fail( +4 );
test_diag( 'Cycle #1' );
test_diag( '    $B => $A' );
test_diag( '    $A => $B' );
memory_cycle_ok( $me ); # Test non-comments
test_test( "Flip-flopped the A/B" );


my $sybil;
$sybil = [ $sybil, \$sybil, $me, \$sybil ];
test_out( "not ok 1" );
test_fail( +11 );
test_diag( 'Cycle #1' );
test_diag( '    @C->[1] => $D' );
test_diag( '    $D => @C' );
test_diag( 'Cycle #2' );
test_diag( '    @C->[2] => $B' );
test_diag( '    $B => $A' );
test_diag( '    $A => $B' );
test_diag( 'Cycle #3' );
test_diag( '    @C->[3] => $D' );
test_diag( '    $D => @C' );
memory_cycle_ok( $sybil ); # Test non-comments
test_test( "Sybil and her sisters" );
