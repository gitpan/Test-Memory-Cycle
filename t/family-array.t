# $Id: family-array.t,v 1.1 2004/01/20 04:53:46 andy Exp $
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

my $dad = {
    name => "Dan Lester",
};

my $me = {
    name => "Andy Lester",
    parents => [$mom,$dad],
};
my $andy = $me;

my $amy = {
    name => "Amy Lester",
};

my $quinn = {
    name => "Quinn Lester",
    parents => [$andy,$amy],
};

$mom->{children} = [$andy];
$mom->{grandchildren} = [$quinn];

test_out( "not ok 1 - The Array Family" );
test_fail( +13 );
test_diag( 'Cycle #1' );
test_diag( '    %A->{parents} => @B' );
test_diag( '    @B->[0] => %C' );
test_diag( '    %C->{grandchildren} => @D' );
test_diag( '    @D->[0] => %E' );
test_diag( '    %E->{parents} => @F' );
test_diag( '    @F->[0] => %A' );
test_diag( 'Cycle #2' );
test_diag( '    %A->{parents} => @B' );
test_diag( '    @B->[0] => %C' );
test_diag( '    %C->{children} => @G' );
test_diag( '    @G->[0] => %A' );
memory_cycle_ok( $me, "The Array Family" );
test_test( "Array family testing" );
