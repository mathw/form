module Form::Field;

use Form::TextFormatting;
use Form::NumberFormatting;

# RAKUDO: Field is now a class, because overriding multis doesn't
# work correctly from roles
our class Field {
	has Bool $.block is rw;
	has Int $.width is rw;
	has $.alignment is rw;
	has $.data is rw;
	
	multi method format(Str $data) { ... }

	multi method format(@data) {
		my @output;
		for @data -> $datum {
			@output.push(self.format($datum));
		}
		return @output;
	}

	method align(@lines, $height) {
		if @lines.elems < $height {
			my @extra = (' ' x $.width) xx ($height - @lines.elems);
			given $.alignment {
				when Alignment::top {
					return (@lines, @extra);
				}
				when Alignment::bottom {
					return (@extra, @lines);
				}
				default {
					my @top = (' ' x $.width) xx (@extra.elems div 2);
					my @bottom = @top;
					@extra.elems % 2 and @bottom.push(' ' x $.width);
					return (@top, @lines, @bottom);
				}
			}
		}
		elsif @lines.elems > $height {
			# TODO: we may need to be cleverer about which alignments
			return @lines[^$height];
		}
		else {
			return @lines;
		}
	}
}

our class TextField is Field {
	has $.justify is rw;


	multi method format(Str $data) {
		my @lines = Form::TextFormatting::unjustified-wrap(~$data, $.width);

		$.block or @lines = @lines[^1];

		my Callable $justify-function;
		if $.justify == Justify::left {
			$justify-function = &Form::TextFormatting::left-justify;
		}
		elsif $.justify == Justify::right {
			$justify-function = &Form::TextFormatting::right-justify;
		}
		elsif $.justify == Justify::centre {
			$justify-function = &Form::TextFormatting::centre-justify;
		}
		else {
			$justify-function = &Form::TextFormatting::full-justify;
		}
		# RAKUDOBUG: .=map: { } doesn't seem to parse, but .map: { } does
		@lines.=map({ $justify-function($_, $.width, ' ') });

		return @lines;
	}
}

our class NumericField is Field {
	has Num $.ints-width;
	has Num $.fracs-width;

    multi method format(Num $data)
	{
		my ($ints, $fractions) = Form::NumberFormatting::obtain-number-parts($data);
		$ints = Form::TextFormatting::right-justify(~$ints, $.ints-width);
		$fractions = Form::TextFormatting::left-justify(~$fractions, $.fracs-width);
		return [ $ints ~ '.' ~ $fractions ];
	}
}

our class VerbatimField is Field {
	multi method format(Str $data) {
		my @lines = $data.split("\n");
		$.block or @lines = @lines[^1];
		for @lines -> $line is rw {
			$line = Form::TextFormatting::left-justify($line, $.width, ' ');
		}

		return @lines;
	}
}


# vim: ft=perl6 sw=4 ts=4 noexpandtab
