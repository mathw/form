#!/home/matthew/Compiling/rakudo/perl6
use v6;

use Form;

# Test parsing of simple text fields

my $leftfield = '{<<<<}';
my $rightfield = '{>>>>}';
my $centreleftblockfield = '{=[[[[[[=}';

Form::Format.parse($leftfield) and say "ok 1";
Form::Format.parse($rightfield) and say "ok 2";
Form::Format.parse($centreleftblockfield) and say "ok 3";

# vim: ft=perl6 sw=4 ts=4 noexpandtab
