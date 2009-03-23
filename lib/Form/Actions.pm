module Form::Actions;

use Form::Field;

# RAKUDO: temporary workaround, Rakudo can't handle enums from other modules yet.
enum Justify <left right centre full>;
enum Alignment <top middle bottom>;

=begin pod
=head3 FormActions

Class containing action methods to be associated with Form grammar defined in Form::Grammar.

=end pod
class FormActions {

    method right_justified_line_field($/) {
		#say "Right justified line field";
		make Form::Field::TextField.new(
			:justify(Justify::right),
			:block(Bool::False),
			:width((~$/).chars)
		);
    }

	method right_justified_block_field($/) {
		#say "Right justified block field";
		make Form::Field::TextField.new(
			:justify(Justify::right),
			:block(Bool::True),
			:width((~$/).chars)
		);
	}

    method left_justified_line_field($/) {
        #say "Left justified line field";
        make Form::Field::TextField.new(
            :justify(Justify::left),
            :block(Bool::False),
            :width((~$/).chars)
        );
    }

	method left_justified_block_field($/) {
		#say "Left justified block field";
		make Form::Field::TextField.new(
			:justify(Justify::left),
			:block(Bool::True),
			:width((~$/).chars)
		);
	}
	
	method right_justified_field($/, $sub) {
		#say "right justified field";
		make $/{$sub}.ast;
	}

	method left_justified_field($/, $sub) {
		#say "left justified field ($sub)";
		make $/{$sub}.ast;
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
		#say $/{$sub}.ast.WHAT;
		make $/{$sub}.ast;
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
