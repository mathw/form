module Form;

enum Justify <left right centre full>;
enum Alignment <top middle bottom>;

grammar Format {
	regex TOP {
		^ '{' <field> '}' $
		{*}
	}

	regex field {
		  <bottom_aligned_field> {*} #= bottom_aligned_field
		| <centre_aligned_field> {*} #= centre_aligned_field
		| <top_aligned_field>    {*} #= top_aligned_field
	}

	regex bottom_aligned_field {
		_ <aligned_field> _
		{*}
	}

	regex centre_aligned_field {
		'=' <aligned_field> '='
		{*}
	}

	regex top_aligned_field {
		<aligned_field>
		{*}
	}

	regex aligned_field {
		  <left_justified_field>  {*} #= left_justified_field
		| <centred_field>         {*} #= centred_field
		| <right_justified_field> {*} #= right_justified_field
		| <fully_justified_field> {*} #= fully_justified_field
	}

	regex left_justified_field {
		  <left_justified_block_field> {*} #= left_justified_block_field
		| <left_justified_line_field>  {*} #= left_justified_line_field
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
		  <right_justified_block_field> {*} #= right_justified_block_field
		| <right_justified_line_field>  {*} #= right_justified_line_field
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
	has @.elements is rw;
}

class Literal {
	has Str $.content is rw;
}

role Field {
	has Bool $.block is rw;
	has Int $.width is rw;
	has $.alignment is rw;
	has $.data is rw;
}

# RAKUDO: Don't know what's correct here, but until [perl #63510] is resolved,
#         we need to write "Form::Field", not "Field".
class TextField does Form::Field {
	has $.justify is rw;
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

	method right_justified_block_field($/) {
		say "Right justified block field";
		make Form::TextField.new(
			:justify(right),
			:block(Bool::True),
			:width((~$/).chars)
		);
	}

	method left_justified_block_field($/) {
		say "Left justified block field";
		make Form::TextField.new(
			:justify(left),
			:block(Bool::True),
			:width((~$/).chars)
		);
	}
	
	method right_justified_field($/, $sub) {
		say "right justified field";
		make $( $/{$sub} );
	}

	method left_justified_field($/, $sub) {
		say "left justified field ($sub)";
		make $( $/{$sub} );
	}

	method aligned_field($/, $sub) {
		say "aligned field ($sub)";
		make $( $/{$sub} );
	}

	method centre_aligned_field($/) {
		say "centre aligned field";
		my $f = $( $/<aligned_field> );
		$f.alignment = Alignment::centre;
		make $f;
	}

	method bottom_aligned_field($/) {
		say "bottom aligned field";
		my $f = $($/<aligned_field>);
		$f.alignment = Alignment::bottom;
		make $f;
	}

	method top_aligned_field($/) {
		say "top aligned field";
		my $f = $( $/<aligned_field> );
		$f.alignment = Alignment::top;
		make $f;
	}

	method field($/, $sub) {
		say "field";
		make $( $/{$sub} );
	}

	method TOP($/) {
		say "TOP";
		make $( $/<field> );
	}
}



sub form(*@args) returns Str is export {
	my @lines;

	return '';
}

# vim: ft=perl6 sw=4 ts=4 noexpandtab

