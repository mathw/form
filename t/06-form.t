use v6;

use Test;
use Form;

plan 12;

ok(Form::form('a') eq "a\n", "Literal");
ok(Form::form('{<<}', 'a') eq "a   \n", "Single left-line field");
ok(Form::form('{<<}a', 'a') eq "a   a\n", "Single left-line field with literal after");
ok(Form::form('{>>}a', 'a') eq "   aa\n", "Single right-line field with literal after");
ok(Form::form('{>>><<}{<<<}', 'a', 'b') eq "   a   b    \n", "Single centred-line field with single left-line field after");
ok(Form::form('{<<}', 'a', '{>>}', 'b') eq "a   \n   b\n", "Two fields");
ok(Form::form(
    '+----+',
    '|{<<}|', 'aa',
    '+----+'
) eq "+----+\n|aa  |\n+----+\n", "Two literals, one field");
dies_ok(-> { Form::form('{<<}{>>}', 'a') }, "Insufficient arguments");
ok(Form::form('{<<<<<}', "The quick brown fox jumps over the lazy dog") eq "The    \n", "Line field overflow");
# TODO: reformat these as here-documents
ok(Form::form('{[[[[[}', "The quick brown fox jumps over the lazy dog") eq "The    \nquick  \nbrown  \nfox    \njumps  \nover   \nthe    \nlazy   \ndog    \n", "Block field overflow");
ok(
    Form::form(
        '{[[[[[[[[} {]]]]]]]]}',
        "The quick brown fox", "jumps over the lazy dog"
    )
    eq
    "The quick  jumps over\nbrown fox    the lazy\n                  dog\n",
    "Multiple block overflow"
);
ok(Form::form('{""}', "Boo\nYah") eq "Boo \nYah \n", "Literal block field");

# vim: ft=perl6 sw=4 ts=4 noexpandtab
