#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More tests => 8;
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

test_out( "ok 1 - Scalar Family has Cycles" );
memory_cycle_exists( $me, "Scalar Family has Cycles" );
test_test( "Simple loopback testing for cycles" );

my $myself = \$me;
$me = \$myself;

test_out( "not ok 1" );
test_fail( +4 );
test_diag( 'Cycle #1' );
test_diag( '    $A => $B' );
test_diag( '    $B => $A' );
memory_cycle_ok( $myself ); # Test non-comments
test_test( "Simple loopback to myself" );

test_out( "ok 1" );
memory_cycle_exists( $myself ); # Test non-comments
test_test( "Simple loopback to myself with cycles" );

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

test_out( "ok 1" );
memory_cycle_exists( $sybil ); # Test non-comments
test_test( "Sybil and her sisters have cycles" );
