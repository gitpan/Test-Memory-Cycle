#$Id: Cycle.pm,v 1.2 2003/12/15 05:34:49 andy Exp $

package Test::Memory::Cycle;

=head1 NAME

Test::Memory::Cycle - check for circular memory references

=head1 VERSION

Version 0.01

    $Header: /home/cvs/test-memory-cycle/Cycle.pm,v 1.2 2003/12/15 05:34:49 andy Exp $

=cut

our $VERSION = "0.01";

=head1 SYNOPSIS

Blah blah blah.  Don't want to leave circular memory references
because they cause leaks.

    use Test::Memory::Cycle;

    my $object = new MyObject;
    ... Do stuff ...
    memory_cycle_ok( $object );

C<Test::Memory::Cycle> relies on Lincoln Stein's L<Devel::Cycle>
to do the dirty work.  I've just put it in a pretty C<Test::*>
package.

=cut

use strict;
use warnings;

use Devel::Cycle qw( find_cycle );
use Test::Builder;

my $Test = Test::Builder->new;

sub import {
    my $self = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::memory_cycle_ok'}       = \&memory_cycle_ok;

    $Test->exported_to($caller);
    $Test->plan(@_);
}

=head1 FUNCTIONS

=head2 C<memory_cycle_ok( I<$object>, I<$msg> )>

Checks that I<$object> doesn't have any circular memory references.

=cut

sub memory_cycle_ok {
    my $ref = shift;
    my $msg = shift;

    my $ok = 1;
    my $cycle_no = 0;

    my $callback = sub {
	my $path = shift;

	if ( $ok ) {
	    $ok = 0;
	    $Test->ok( $ok, $msg );
	}

	$cycle_no++;
	$Test->diag( "Cycle ($cycle_no)" );
	foreach (@$path) {
	    my ($type,$index,$ref,$value) = @$_;

	    my $str = "Unknown! This should never happen!";
	    my $refdisp = _ref_shortname( $ref );
	    my $valuedisp = _ref_shortname( $value );

	    
	    $str = sprintf("\t%30s => %-30s\n",$refdisp,$valuedisp)               if $type eq 'SCALAR';
	    $str = sprintf("\t%30s => %-30s\n","${refdisp}->[$index]",$valuedisp) if $type eq 'ARRAY';
	    $str = sprintf("\t%30s => %-30s\n","${refdisp}->{$index}",$valuedisp) if $type eq 'HASH';

	    $Test->diag( $str );
	}
    };

    find_cycle( $ref, $callback );
    $Test->ok( $ok, $msg ) if $ok;

    return $ok;
} # memory_cycle_ok

my %shortnames;
my $new_shortname = "A";

sub _ref_shortname {
    my $ref = shift;
    my $refstr = "$ref";
    my $refdisp = $shortnames{ $refstr };
    if ( !$refdisp ) {
	my $sigil = ref($ref) . " ";
	$sigil = '%' if $sigil eq "HASH ";
	$sigil = '@' if $sigil eq "ARRAY ";
	$sigil = '$' if $sigil eq "SCALAR ";
	$refdisp = $shortnames{ $refstr } = $sigil . $new_shortname++;
    }

    return $refdisp;
}

=head1 AUTHOR

Written by Andy Lester, C<< <andy@petdance.com> >>.

=head1 COPYRIGHT

Copyright 2003, Andy Lester, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.

=cut

1;
