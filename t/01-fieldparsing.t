use v6;

use Test;

plan 14;

use Form::Grammar;

ok(Form::Grammar::Format.parse('abcdefghijklm nopqrstuvwxyz.'), 'Plain literal string parses');
ok(Form::Grammar::Format.parse('{[[[[[[}'), 'Simple left block field parses');
ok(Form::Grammar::Format.parse('{]]]}'), 'Simple right block field parses');
ok(Form::Grammar::Format.parse('{<<<<<<<<}'), 'Simple left line field parses');
ok(Form::Grammar::Format.parse('{>>>>>}'), 'Simple right line field parses');
ok(Form::Grammar::Format.parse('{[[]]}'), 'Simple block justified field parses');
ok(Form::Grammar::Format.parse('{<<<>>}'), 'Simple line justified field parses');
ok(Form::Grammar::Format.parse('{>><<}'), 'Simple centred line field parses');
ok(Form::Grammar::Format.parse('{]]]][[[}'), 'Simple centred block field parses');
ok(Form::Grammar::Format.parse('abc {[[[[} def'), 'Left block field inside literals parses');
ok(Form::Grammar::Format.parse('{<<<}wibble'), 'Left line field before literal parses');
ok(Form::Grammar::Format.parse('floob{<<>}'), 'Centred line field after literal parses');
ok(Form::Grammar::Format.parse('{|||||||}'), 'Centred line field (alternative)');
ok(Form::Grammar::Format.parse('{IIII}'), 'Centred block field (alternative)');

# vim: ft=perl6 sw=4 ts=4 noexpandtab
