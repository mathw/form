module Form::Actions;

use Form::Field;

=begin pod
=head3 FormActions

Class containing action methods to be associated with Form grammar defined in Form::Grammar.

=end pod

class FormActions {

	method centred_field($/, $sub) {
		make $/{$sub}.ast;
	}

	method centred_block_field($/) {
		make Form::Field::TextField.new(
			:justify(Justify::centre),
			:block(Bool::True),
			:width((~$/).chars + 2)
		);
	}

	method centred_line_field($/) {
		make Form::Field::TextField.new(
			:justify(Justify::centre),
			:block(Bool::False),
			:width((~$/).chars + 2)
		);
	}

	method fully_justified_field($/, $sub) {
		make $/{$sub}.ast;
	}

	method justified_line_field($/) {
		make Form::Field::TextField.new(
			:justify(Justify::full),
			:block(Bool::False),
			:width((~$/).chars + 2)
		);
	}

	method justified_block_field($/) {
		make Form::Field::TextField.new(
			:justify(Justify::full),
			:block(Bool::True),
			:width((~$/).chars + 2)
		);
	}

    method right_justified_line_field($/) {
		make Form::Field::TextField.new(
			:justify(Justify::right),
			:block(Bool::False),
			:width((~$/).chars + 2)
		);
    }

	method right_justified_block_field($/) {
		make Form::Field::TextField.new(
			:justify(Justify::right),
			:block(Bool::True),
			:width((~$/).chars + 2)
		);
	}

    method left_justified_line_field($/) {
        make Form::Field::TextField.new(
            :justify(Justify::left),
            :block(Bool::False),
            :width((~$/).chars + 2)
        );
    }

	method left_justified_block_field($/) {
		make Form::Field::TextField.new(
			:justify(Justify::left),
			:block(Bool::True),
			:width((~$/).chars + 2)
		);
	}
	
	method right_justified_field($/, $sub) {
		make $/{$sub}.ast;
	}

	method left_justified_field($/, $sub) {
		make $/{$sub}.ast;
	}

	method numeric_field($/, $sub) {
		make $/{$sub}.ast;
	}

	method numeric_block_field($/) {
		make Form::Field::NumericField.new(
			:block(Bool::True),
			:width((~$/).chars + 2),
			:ints-width((~$/[0]).chars + 1),
			:fracs-width((~$/[1]).chars + 1)
		);
	}

	method numeric_line_field($/) {
		make Form::Field::NumericField.new(
			:block(Bool::False),
			:width((~$/).chars + 2),
			:ints-width((~$/[0]).chars + 1),
			:fracs-width((~$/[1]).chars + 1)
		);
	}

	method verbatim_field($/, $sub) {
		make $/{$sub}.ast;
	}

	method verbatim_line_field($/) {
		make Form::Field::VerbatimField.new(
			:block(Bool::False),
			:width((~$/).chars + 2)
		);
	}
	
	method verbatim_block_field($/) {
		make Form::Field::VerbatimField.new(
			:block(Bool::True),
			:width((~$/).chars + 2)
		);
	}

	method aligned_field($/, $sub) {
		#say "aligned field ($sub)";
		make $/{$sub}.ast;
	}

	method centre_aligned_field($/) {
		#say "centre aligned field";
		my $f = $/<aligned_field>.ast;
		$f.alignment = Alignment::centre;
		make $f;
	}

	method bottom_aligned_field($/) {
		#say "bottom aligned field";
		my $f = $/<aligned_field>.ast;
		$f.alignment = Alignment::bottom;
		make $f;
	}

	method top_aligned_field($/) {
		#say "top aligned field";
		my $f = $/<aligned_field>.ast;
		$f.alignment = Alignment::top;
		make $f;
	}

	method field($/, $sub) {
		#say "field $sub";
		make $/{$sub}.ast;
	}

	method field_or_literal($/, $sub) {
		make $/{$sub}.ast;
	}

	method literal($/) {
		make ~$/;
	}

	method TOP($/) {
		#say "TOP";

        # gather, in order, the sequence of <literal> and <field> matches
        # make a list of those
        # What we do is iterate through the submatches and pull out the result objects into an array
        # Might as well do it lazily
        # The question is, is this the right way to get the list of submatches
        # since $/[0] etc. work, $/ in list context should be that list...
        my @matches = gather for @( $/<field_or_literal> ) -> $m {
            take $m.ast; 
        }
		
		make @matches;
	}
}

# vim: ft=perl6 sw=4 ts=4 noexpandtab
