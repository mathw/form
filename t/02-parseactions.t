#
use v6;
use Test;

plan 6;

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

my $result = Form::Format.parse('{[[[[[}', :action($actions));
ok($result, "Parse left block field with actions succeeds");


my $field = $($result);
ok($field ~~ Form::Field, "Parse returned Form::Field result object (it was a {$($field).WHAT})");

ok($field.block, "Parsed left block field block state is true");
ok($field.width == 5, "Parsed left block field width is correct");
#ok($field.alignment == Form::Alignment::top, "Parsed left block field alignment is top");
#ok($field.justify == Form::Justify::left, "Parsed left block field justification is left");

# vim: ft=perl6 sw=4 ts=4 noexpandtab
