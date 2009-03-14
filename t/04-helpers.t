#!/usr/bin/env perl6

use v6;

use Test;

use Form;

plan 6;

my $text = "The quick brown fox, jumps over the lazy dog.";
my $fitted;
my $remainder;

($fitted, $remainder) = Form::fit_in_width($text, 6);
ok($fitted eq 'The ', "First line fitted correctly");
ok($remainder eq 'quick brown fox, jumps over the lazy dog.', "First line remainder correct");
($fitted, $remainder) = Form::fit_in_width($text, 20);
ok($fitted eq 'The quick brown fox,', "Wider line fitted correctly");
ok($remainder eq 'jumps over the lazy dog.', "Wider line remainder correct");
($fitted, $remainder) = Form::fit_in_width($text, 2);
ok($fitted eq 'Th', 'Partial word fill correct');
ok($remainder eq 'e quick brown fox, jumps over the lazy dog.', 'Partial word remainder correct');

