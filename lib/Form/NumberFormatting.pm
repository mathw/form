module Form::NumberFormatting;

use Form::TextFormatting;

=begin pod

=head1 Form::NumberFormatting

Utility functions for formatting numbers in Form.pm.

=end pod


=begin pod

=head2 obtain-number-parts(Num $number)

Splits out the integer and non-integer components of a number. Returns a list of int part, float part.

This should probably be done with mathematical operations rather than Str::split, but once floating-point gets involved it breaks, so that's a TODO until RAKUDO has the Rat type and we can do it sanely.

=end pod

sub obtain-number-parts(Num $number) {
    my ($ints, $fractions) = (~$number).split(/\./);

    return (+$ints, +$fractions);
}

=begin pod

=end pod


# vim: ft=perl6 sw=4 ts=4 noexpandtab

