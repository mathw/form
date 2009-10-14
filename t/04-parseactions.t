#
use v6;
use Test;

plan 32;

use Form::Grammar;
use Form::Actions;
use Form::Field;

my $actions = Form::Actions::FormActions.new;
ok($actions, "Form::FormActions constructs");

my $result = Form::Grammar::Format.parse('{[[[}', :action($actions));
ok($result, "Parse left block field with actions succeeds");


my $fields = $result.ast;
my $field = $fields[0];
ok($field ~~ Form::Field::TextField, "Parse returned Form::Field::TextField result object (it was a {$field.WHAT})");

ok($field.block, "Parsed left block field block state is true");
ok($field.width == 5, "Parsed left block field width is correct");
# RAKUDO: enable these after Rakudo lets us talk to enums in another module
#ok($field.alignment == Form::TextFormatting::Alignment::top, "Parsed left block field alignment is top");
#ok($field.justify == Form::TextFormatting::Justify::left, "Parsed left block field justification is left");

my $r-result = Form::Grammar::Format.parse('{>>>>>>}', :action($actions));
ok($r-result, "Parse right line field with actions succeeds");

my $r-field = $r-result.ast[0];
ok($r-field ~~ Form::Field::TextField, "Parse returned a Form::Field::TextField result object");
ok(!$r-field.block, "Parsed right line field object is not a block");
ok($r-field.width == 8, "Parsed right line field width is correct");
#ok($field.alignment == Form::TextFormatting::Alignment::top, "Parsed right line field alignment is top");
#ok($field.justify == Form::TextFormatting::Justify::right, "Parsed right line field justification is left");

$r-result = Form::Grammar::Format.parse('{><}', :action($actions));
ok($r-result, "Parse centred line field with actions succeeds");
ok($r-result.ast[0] ~~ Form::Field::TextField, "Parse centred line field result object is TextField");
ok($r-result.ast[0].width == 4, "Parsed centred line field has correct width");
# RAKUDO: enable when we can use enums from another module
#ok($r-result.ast[0].justify == Form::TextFormatting::Justify::centre, "Parsed centred line field justification is centre");

$r-result = Form::Grammar::Format.parse('{[[]}', :action($actions));
ok($r-result, "Parse justified line field with actions succeeds");
ok($r-result.ast[0] ~~ Form::Field::TextField, "Parse justified line field result object is TextField");
ok($r-result.ast[0].width == 5, "Parsed justified line field has correct width");
# RAKUDO: enable when we can use enums from another module
#ok($r-result.ast[0].justify == Form::TextFormatting::Justify::full, "Parsed centred line field justification is centre");



# Now for mixed literals, multiple fields
my $mixed-string = 'hello{[[[} goodbye{>>}{><}';
my $mixed-results = Form::Grammar::Format.parse($mixed-string, :action($actions));
ok($mixed-results.ast ~~ Array, "Mixed field parse returned an array");
ok($mixed-results.ast.elems == 5, "Mixed field parse had the correct number of elements");

my $c = 1;
for $mixed-results.ast Z (Str, Form::Field::TextField, Str, Form::Field::TextField, Form::Field::TextField) -> $r, $e {
	ok($r ~~ $e, "Mixed field section {$c++} has type $e ({$r.WHAT})");
}

my $v-string = '{\'\'\'}';
my $v-results = Form::Grammar::Format.parse($v-string, :action($actions));
ok($v-results.ast ~~ Array, "Verbatim field parse returned an array");
ok($v-results.ast.elems == 1, "Verbatim field parse has one element");
ok($v-results.ast[0] ~~ Form::Field::VerbatimField, "Verbatime field object is a VerbatimField");
ok($v-results.ast[0].width == 5, "Verbatim field object has correct width");
ok($v-results.ast[0].block == Bool::False, "Verbatim field object is not a block");


{
	my $source = '{>>>.<<<}';
	my $r = Form::Grammar::Format.parse($source, action => $actions);
	ok($r.ast ~~ Array, "Numeric field parse returned an array");
	my $ast = $r.ast;
	ok($ast.elems == 1, "Numeric field parse has one element");
	my $field = $ast[0];
	ok($field.block == Bool::False, "Numeric field object is not a block");
	ok($field.ints-width == 4, "Numeric field int-width is correct");
	ok($field.fracs-width == 4, "Numeric field fracs-width is correct");
}

# vim: ft=perl6 sw=4 ts=4 noexpandtab
