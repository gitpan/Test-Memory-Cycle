package Test::Memory::Cycle;

=head1 NAME

Test::Memory::Cycle - Check for memory leaks and circular memory references

=head1 VERSION

Version 1.00

=cut

our $VERSION = "1.00";

=head1 SYNOPSIS

Perl's garbage collection has one big problem: Circular references
can't get cleaned up.  A circular reference can be as simple as two
objects that refer to each other:

    my $mom = {
        name => "Marilyn Lester",
    };

    my $me = {
        name => "Andy Lester",
        mother => $mom,
    };
    $mom->{son} = $me;

C<Test::Memory::Cycle> is built on top of C<Devel::Cycle> to give
you an easy way to check for these circular references.

    use Test::Memory::Cycle;

    my $object = new MyObject;
    # Do stuff with the object.
    memory_cycle_ok( $object );

You can also use C<memory_cycle_exists()> to make sure that you have a
cycle where you expect to have one.

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
    *{$caller.'::memory_cycle_exists'}   = \&memory_cycle_exists;

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

    my $cycle_no = 0;
    my @diags;

    # Callback function that is called once for each memory cycle found.
    my $callback = sub {
        my $path = shift;
        $cycle_no++;
        push( @diags, "Cycle #$cycle_no" );
        foreach (@$path) {
            my ($type,$index,$ref,$value) = @$_;

            my $str = "Unknown! This should never happen!";
            my $refdisp = _ref_shortname( $ref );
            my $valuedisp = _ref_shortname( $value );

            $str = sprintf("    %s => %s",$refdisp,$valuedisp)               if $type eq 'SCALAR';
            $str = sprintf("    %s => %s","${refdisp}->[$index]",$valuedisp) if $type eq 'ARRAY';
            $str = sprintf("    %s => %s","${refdisp}->{$index}",$valuedisp) if $type eq 'HASH';

            push( @diags, $str );
        }
    };

    find_cycle( $ref, $callback );
    my $ok = !$cycle_no;
    $Test->ok( $ok, $msg );
    $Test->diag( join( "\n", @diags, "" ) ) unless $ok;

    return $ok;
} # memory_cycle_ok


=head2 C<memory_cycle_exists( I<$object>, I<$msg> )>

Checks that I<$object> B<does> have any circular memory references.

=cut

sub memory_cycle_exists {
    my $ref = shift;
    my $msg = shift;

    my $cycle_no = 0;
    my @diags;

    # Callback function that is called once for each memory cycle found.
    my $callback = sub { $cycle_no++ };

    find_cycle( $ref, $callback );
    my $ok = $cycle_no;
    $Test->ok( $ok, $msg );

    return $ok;
} # memory_cycle_exists

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
        $sigil = '$' if $sigil eq "REF ";
        $refdisp = $shortnames{ $refstr } = $sigil . $new_shortname++;
    }

    return $refdisp;
}

=head1 AUTHOR

Written by Andy Lester, C<< <andy@petdance.com> >>.

=head1 COPYRIGHT

Copyright 2004, Andy Lester, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.

=cut

1;
