#!/usr/bin/env perl6

use v6;

use Test;

use Form;

plan 3;

my $haystack = "eeeaeaa";
my $needle = "e";

my $where = Form::rindex($haystack, $needle);
ok($where == 4, "rindex('$haystack', '$needle') == 4");
$where = Form::rindex($haystack, 'z');
ok(!defined($where), "rindex('$haystack', 'z') untrue");
$where = Form::rindex($haystack, 'a');
ok($where == 6, "rindex('$haystack', 'a') == 6");
