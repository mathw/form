module Form;

use Form::TextFormatting;
use Form::Grammar;
use Form::Actions;
use Form::Field;

sub form(*@args is Scalar) returns Str is export {
	my @lines;
	my $result = '';

	my $actions = Form::Actions::FormActions.new;

	while @args.elems {
		my $format = @args.shift;
		my $f = Form::Grammar::Format.parse($format, :action($actions));
		my @fields = $f.ast;
		@fields or die "form: error: argument '$format' is not a valid format string";
		my $nonliteral-field-count = @fields.grep({!($_ ~~ Str)}).elems;
		if @args.elems < $nonliteral-field-count {
			die "Insufficient number of data arguments ({@args.elems}) provided for format template '$format'";
		}

		my @data;
		for ^$nonliteral-field-count {
			@data.push(@args.shift);
		}

		my @formatted;

		for @fields {
			when Str {
				@formatted.push([$_]);
			}
			when Form::Field::Field {
				@formatted.push([.format(@data.shift)]);
			}
		}

		my $most-lines = ([max] @formatted.map: *.elems);
		for @fields Z @formatted -> $field, $flines is rw {
			if $flines.elems < $most-lines {
				if $field ~~ Form::Field::Field {
					$flines = $field.align($flines, $most-lines);
				}
				elsif $field ~~ Str {
					$flines = $field xx $most-lines;
				}
			}
		}

		for ^$most-lines -> $line-number {
			my $line;
			for @formatted {
				$line ~= $_[$line-number];
			}
			$result ~= $line ~ "\n";
		}
	}

	return $result;
}

# vim: ft=perl6 sw=4 ts=4 noexpandtab

