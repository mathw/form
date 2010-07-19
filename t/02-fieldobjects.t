use v6;
use Test;

plan 4;

use Form::Field;

my $textfield;
lives_ok(
	{
		$textfield = Form::Field::TextField.new;
	},
	"TextField constructs with no parameters"
);

ok($textfield, "TextField constructor returned an object");

{
    my $numeric-field;
    lives_ok( { $numeric-field = Form::Field::NumericField.new; },
              'NumericField constructs with no parameters'
    );
    ok($numeric-field.defined, 'NumericField constructor returned an object');
}

# todo more of these please!

# vim: ft=perl6 sw=4 ts=4 noexpandtab
