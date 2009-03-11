#
use v6;
use Test;

plan 4;

use Form;

# Need to make 02 be testing the field objects, move this file to 03
my $textfield = Form::TextField.new(
	:justify(Form::right),
	:block(Bool::True),
	:width(3)
);
ok($textfield, "Form::TextField can be constructed");

my $actions = Form::FormActions.new;
ok($actions, "Form::FormActions constructs");

my $field = Form::Format.parse('{[[[[[}', :action($actions));
ok($field, "Parse left block field with actions succeeds");

ok($($field) ~~ Form::Field, "Parse returned Form::Field result object (it was a {$($field).WHAT})");

# vim: ft=perl6 sw=4 ts=4 noexpandtab
