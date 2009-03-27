module Form::Field;

role Field {
	has Bool $.block is rw;
	has Int $.width is rw;
	has $.alignment is rw;
	has $.data is rw;
}

# RAKUDO: Don't know what's correct here, but until [perl #63510] is resolved,
#         we need to write "Form::Field::Field", not "Field".
class TextField does Form::Field::Field {
	has $.justify is rw;
}

# RAKUDO: Don't know what's correct here, but until [perl #63510] is resolved,
#         we need to write "Form::Field::Field", not "Field".
class VerbatimField does Form::Field::Field {
}


# vim: ft=perl6 sw=4 ts=4 noexpandtab
