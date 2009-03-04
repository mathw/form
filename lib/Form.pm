module Form;

enum Justify <left right centre full>;
enum Alignment <top middle bottom>;

grammar Format {
	regex TOP {
		^ '{' <field> '}' $
		{*}
	}

	regex field {
		<bottom_aligned_field> | <centre_aligned_field> | <aligned_field>
		{*}
	}

	regex bottom_aligned_field {
		_ <aligned_field> _
		{*}
	}

	regex centre_aligned_field {
		'=' <aligned_field> '='
		{*}
	}

	regex aligned_field {
		<left_justified_field> | <centred_field> | <right_justified_field> | <fully_justified_field>
		{*}
	}

	regex left_justified_field {
		<left_justified_block_field> | <left_justified_line_field>
		{*}
	}

	regex left_justified_block_field {
		'['+
		{*}
	}

	regex left_justified_line_field {
		'<'+
		{*}
	}

	regex centred_field {
		<centred_block_field> | <centred_line_field>
		{*}
	}

	regex centred_block_field {
		']'+ '['+
		{*}
	}

	regex centred_line_field {
		'>'+ '<'+
		{*}
	}

	regex right_justified_field {
		<right_justified_block_field> | <right_justified_line_field>
		{*}
	}

	regex right_justified_block_field {
		']'+
		{*}
	}
	
	regex right_justified_line_field {
		'>'+
		{*}
	}

	regex fully_justified_field {
		<justified_block_field> | <justified_line_field>
		{*}
	}

	regex justified_block_field {
		'['+ ']'+
		{*}
	}

	regex justified_line_field {
		'<'+ '>'+
		{*}
	}
}

class Picture {
	# @.elements is Str|Field when Rakudo supports that
	has @.elements;
}

class Literal {
	has Str $.content;
}

role Field {
	has Bool $.block;
	has Int $.width;
	has $.alignment;
	has $.data;
}

# RAKUDO: Don't know what's correct here, but until [perl #63510] is resolved,
#         we need to write "Form::Field", not "Field".
class TextField does Form::Field {
	has $.justify;
}

# RAKUDO: Don't know what's correct here, but until [perl #63510] is resolved,
#         we need to write "Form::Field", not "Field".
class VerbatimField does Form::Field {
}


=begin pod

=head3 FormActions

Class containing action methods to be associated with Form grammar.

RAKUDO: This is temporary until Rakudo supports calling make from a closure in the rule itself.

=end pod
class FormActions {

	method right_justified_block_field($m) {
		say "Right justified block field";
		make TextField.new(
			:justify(Justify::right),
			:block(Bool::True),
			:width((~$m).chars)
		);
	}

	method left_justified_block_field($m) {
		say "Left justified block field";
		make TextField.new(
			:justify(Justify::left),
			:block(Bool::True),
			:width((~$m).chars)
		);
	}
	
	method right_justified_field($m) {
		say "right justified field";
		make $m;
	}

	method aligned_field($m) {
		say "aligned field";
		make $m;
	}

	method centre_aligned_field($m) {
		say "centre aligned field";
		$m.alignment = Alignment::centre;
		make $m;
	}

	method bottom_aligned_field($m) {
		say "bottom aligned field";
		$m.alignment = Alignment::bottom;
		make $m;
	}

	method top_aligned_field($m) {
		say "top aligned field";
		$m.alignment = Alignment::top;
		make $m;
	}

	method field($m) {
		say "field";
		make $m;
	}

	method TOP($m) {
		say "TOP";
		make $m;
	}
}



sub form(*@args) returns Str is export {
	my @lines;

	return '';
}

# vim: ft=perl6 sw=4 ts=4 noexpandtab

