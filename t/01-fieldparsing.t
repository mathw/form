use v6;

use Test;

plan 8;

use Form;

ok(Form::Format.parse('{[[[[[[}'), 'Simple left block field parses');
ok(Form::Format.parse('{]]]}'), 'Simple right block field parses');
ok(Form::Format.parse('{<<<<<<<<}'), 'Simple left line field parses');
ok(Form::Format.parse('{>>>>>}'), 'Simple right line field parses');
ok(Form::Format.parse('{[[]]}'), 'Simple block justified field parses');
ok(Form::Format.parse('{<<<>>}'), 'Simple line justified field parses');
ok(Form::Format.parse('{>><<}'), 'Simple centred line field parses');
ok(Form::Format.parse('{]]]][[[}'), 'Simple centred block field parses');

# vim: ft=perl6 sw=4 ts=4 noexpandtab
