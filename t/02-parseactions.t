#
use v6;
use Test;

plan 2;

use Form;

my $actions = Form::FormActions.new;
ok($actions, "Form::FormActions constructs");

my $field = Form::Format.parse('{[[[[[}', :actions($actions));
ok($field, "Parse left block field with actions succeeds");
# vim: ft=perl6 sw=4 ts=4 noexpandtab
