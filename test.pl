#!perl6
use v6;

use Form;

# Test parsing of simple text fields

my $leftfield = '{<<<<}';
my $rightfield = '{>>>>}';
my $centreleftblockfield = '{=[[[[[[=}';

# RAKUDO: cannot use .parse on many-jointed namespace [perl #63462]
#Form::Format.parse($leftfield) and say "ok 1";
$leftfield ~~ /<Form::Format::TOP>/ and say 'ok 1';
#Form::Format.parse($rightfield) and say "ok 2";
$rightfield ~~ /<Form::Format::TOP>/ and say 'ok 2';
#Form::Format.parse($centreleftblockfield) and say "ok 3";
$centreleftblockfield ~~ /<Form::Format::TOP>/ and say 'ok 3';

# vim: ft=perl6 sw=4 ts=4 noexpandtab
