#!/usr/bin/env perl6

use v6;

use Test;

use Form::TextFormatting;

plan 8;

my $text = "The quick brown fox, jumps over the lazy dog.";
my $fitted;
my $remainder;

($fitted, $remainder) = Form::TextFormatting::fit_in_width($text, 6);
say "'$fitted'";
ok($fitted eq 'The', "First line fitted correctly");
ok($remainder eq 'quick brown fox, jumps over the lazy dog.', "First line remainder correct");
($fitted, $remainder) = Form::TextFormatting::fit_in_width($text, 20);
ok($fitted eq 'The quick brown fox,', "Wider line fitted correctly");
ok($remainder eq 'jumps over the lazy dog.', "Wider line remainder correct");
($fitted, $remainder) = Form::TextFormatting::fit_in_width($text, 2);
ok($fitted eq 'Th', 'Partial word fill correct');
ok($remainder eq 'e quick brown fox, jumps over the lazy dog.', 'Partial word remainder correct');


# now wrapping whole sets of lines
my @lines = Form::TextFormatting::unjustified_wrap($text, 6);
# okay, we should have...
my @expected = <The quick brown fox, jumps over the lazy dog.>;
ok(@lines.elems == 9, "Correct number of lines.");
my $lines_correct = all(map -> $g, $e { $g eq $e }, (@lines Z @expected)) == 1;
ok($lines_correct, "Lines were correct");
