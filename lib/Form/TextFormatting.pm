module Form::TextFormatting;


=begin pod

=head1 Form::TextFormatting

Utility functions for formatting text in Form.pm.

=end pod

enum Justify <left right centre full>;
enum Alignment <top middle bottom>;

sub chop_first_word(Str $source is rw) returns Str {
	if $source ~~ / ^^ (\S+) \s* (.*) $$ / {
		my $word = ~$/[0];
		$source = ~$/[1];
		return $word;
	}
	else {
		return '';
	}
}

sub fit_in_width(Str $text, Int $width) #{returns Array of Str} {

	my Str $fitted = '';
	my Str $remainder = $text;
	my Str $word;
	
	while $word = chop_first_word($remainder) {
		if $fitted.chars + $word.chars <= $width {
			$fitted ~= $word;
			if $fitted.chars < $width {
				$fitted ~= ' ';
			}
			else {
				# done - no room for a space means no
				# room for another word
				last;
			}
		}
		else {
			# won't fit - put the word back
			$remainder = "$word $remainder";
			last;
		}
	}

	# final check - did we fit anything in?
	# if the word is too long, we have to split it
	if $fitted eq '' {
		$fitted = $remainder.substr(0, $width);
		$remainder.=substr($width);
	}

	return (trim_ending_whitespace($fitted), $remainder);
}


sub unjustified_wrap(Str $text, Int $width) #{returns Array of Str} {
	my $rem = $text;
	my $line;

	my @array = gather loop {
		($line, $rem) = fit_in_width($rem, $width);
		# we have to force a copy here or take will end up with the same value
		# every single time! This might be a rakudo issue, or a spec issue
		# or just expected behaviour
		my $t = $line;
		take $t;
		$rem or last;
	};

	return @array;
}

sub trim_ending_whitespace(Str $line) returns Str {
	return $line.subst(/ <ws> $$ /, '');
}

sub left-justify(Str $line, Int $width, Str $space = ' ') returns Str {
	if $line.chars < $width {
		return $line ~ (($space x ($width - $line.chars) / $space.chars));
	}

	return $line.substr(0, $width);
}

sub right-justify(Str $line, Int $width, Str $space = ' ') returns Str {
	if $line.chars < $width {
		return ($space x (($width - $line.chars) / $space.chars)) ~ $line;
	}

	return $line.substr(0, $width);
}

sub centre-justify(Str $line, Int $width, Str $space = ' ') returns Str {
	if $line.chars < $width {
		my Int $to-add = $width - $line.chars;
		my Int $before = int($to-add / 2);
		my Int $after = $before + $to-add % 2;
		$before /= $space.chars;
		$after /= $space.chars;
		return ($space x $before) ~ $line ~ ($space x $after);
	}

	return $line.substr(0, $width);
}

sub full-justify(Str $line, Int $width, Str $space = ' ') returns Str {
	# TODO need a justify algorithm
	# for now, do something entirely unsatisfactory
	if $line.chars < $width {
		my Str @words = $line.comb;
		my $to-add = $width - $line.chars;
		my $words = @words.elems;
		my @spaces = $space xx ($words - 1);
		my $words-width = [+] @words.map({ .chars });
		my $spaces-width = [+] @spaces.map({ .chars });
		my $act-space = 0;
		while $words-width + $spaces-width < $width
		{
			@spaces[$act-space++] ~= $space;
			$spaces-width = [+] @spaces.map({ .chars });
			$act-space >= @spaces.elems and $act-space = 0;
		}

		@spaces.push('');

		return [~] (@words Z @spaces);
	}

	return $line.substr(0, $width);
}

# vim: ft=perl6 ts=4 sw=4 noexpandtab
