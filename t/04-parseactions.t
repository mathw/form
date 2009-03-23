#
use v6;
use Test;

plan 9;

use Form::Grammar;
use Form::Actions;
use Form::Field;

my $actions = Form::Actions::FormActions.new;
ok($actions, "Form::FormActions constructs");

my $result = Form::Grammar::Format.parse('{[[[[[}', :action($actions));
ok($result, "Parse left block field with actions succeeds");


my $fields = $result.ast;
my $field = $fields[0];
ok($field ~~ Form::Field::TextField, "Parse returned Form::Field::TextField result object (it was a {$field.WHAT})");

ok($field.block, "Parsed left block field block state is true");
ok($field.width == 5, "Parsed left block field width is correct");
#ok($field.alignment == Form::TextFormatting::Alignment::top, "Parsed left block field alignment is top");
#ok($field.justify == Form::TextFormatting::Justify::left, "Parsed left block field justification is left");

my $r-result = Form::Grammar::Format.parse('{>>>>>>>>}', :action($actions));
ok($r-result, "Parse right line field with actions succeeds");

my $r-field = $r-result.ast[0];
ok($r-field ~~ Form::Field::TextField, "Parse returned a Form::Field::TextField result object");
ok(!$r-field.block, "Parsed right line field object is not a block");
ok($r-field.width == 8, "Parsed right line field width is correct");
#ok($field.alignment == Form::TextFormatting::Alignment::top, "Parsed right line field alignment is top");
#ok($field.justify == Form::TextFormatting::Justify::right, "Parsed right line field justification is left");



# vim: ft=perl6 sw=4 ts=4 noexpandtab
