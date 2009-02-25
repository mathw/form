use v6;

use Test;

plan 1;

use Form;

ok('{[[[[[[}' ~~ Form::Format::TOP, 'Simple left block field parses');

# vim: ft=perl6 sw=4 ts=4 noexpandtab
