# $Id: good.t,v 1.1 2003/12/15 03:20:04 andy Exp $
use strict;

use Test::Builder::Tester tests => 2;
use Test::More;
use CGI;

BEGIN {
    use_ok( 'Test::Memory::Cycle' );
}

GOOD: {
    my $cgi = new CGI;

    memory_cycle_ok( $cgi, "CGI doesn't leak" );
}
