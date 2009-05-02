use v6;

use Test;

plan 20;

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
ok(Form::Grammar::Format.parse('{>>>>>>=}'), 'Middled end marker');
ok(Form::Grammar::Format.parse('{=>>>>>>}'), 'Middled start marker');
ok(Form::Grammar::Format.parse('{>>>>>>_}'), 'Bottomed end marker');
ok(Form::Grammar::Format.parse('{_>>>>>>}'), 'Bottomed start marker');
ok(Form::Grammar::Format.parse('{\'\'\'\'\'\'\'\'\'\'}'), "Verbatim line field");
ok(Form::Grammar::Format.parse('{""""""""""}'), "Verbatim block field");

# vim: ft=perl6 sw=4 ts=4 noexpandtab
