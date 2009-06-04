module Form::Field;

use Form::TextFormatting;

# RAKUDO: Field is now a class, because overriding multis doesn't
# work correctly from roles
class Field {
	has Bool $.block is rw;
	has Int $.width is rw;
	has $.alignment is rw;
	has $.data is rw;
	
	multi method format(Str $data) { ... }

	multi method format(Array $data) {
		my @output;
		for $data -> $datum {
			@output.push(self.format($datum));
		}
	}

	method align(@lines, $height) {
		if @lines.elems < $height {
			my @extra = (' ' x $.width) xx ($height - @lines.elems);
			if $.alignment == Alignment::top {
				return (@lines, @extra);
			}
			elsif $.alignment == Alignment::bottom {
				return (@extra, @lines);
			}
			else {
				my @top = (' ' x $.width) xx (int(@extra.elems / 2));
				my @bottom = @top;
				@extra.elems % 2 and @bottom.push(' ' x $.width);
				return (@top, @lines, @bottom);
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


# RAKUDO: Don't know what's correct here, but until [perl #63510] is resolved,
#         we need to write "Form::Field::Field", not "Field".
class TextField is Form::Field::Field {
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

# RAKUDO: Don't know what's correct here, but until [perl #63510] is resolved,
#         we need to write "Form::Field::Field", not "Field".
class VerbatimField is Form::Field::Field {
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
