PERL6=perl6
PERL6LIB='/home/matthew/Development/form/lib'

SOURCES=lib/Form/TextFormatting.pm lib/Form/NumberFormatting.pm \
        lib/Form/Field.pm lib/Form/Actions.pm lib/Form/Grammar.pm \
        lib/Test.pm lib/Form.pm

PIRS=$(patsubst %.pm6,%.pir,$(SOURCES:.pm=.pir))

.PHONY: test clean

all: $(PIRS)

%.pir: %.pm
	env PERL6LIB=$(PERL6LIB) $(PERL6) --target=pir --output=$@ $<

%.pir: %.pm6
	env PERL6LIB=$(PERL6LIB) $(PERL6) --target=pir --output=$@ $<

clean:
	rm -f $(PIRS)

test: all
	env PERL6LIB=$(PERL6LIB) prove -e '$(PERL6)' -r --nocolor t/

install: all
	install -D lib/Form/TextFormatting.pir ~/.perl6/lib/Form/TextFormatting.pir
	install -D lib/Form/NumberFormatting.pir ~/.perl6/lib/Form/NumberFormatting.pir
	install -D lib/Form/Field.pir ~/.perl6/lib/Form/Field.pir
	install -D lib/Form/Actions.pir ~/.perl6/lib/Form/Actions.pir
	install -D lib/Form/Grammar.pir ~/.perl6/lib/Form/Grammar.pir
	install -D lib/Test.pir ~/.perl6/lib/Test.pir
	install -D lib/Form.pir ~/.perl6/lib/Form.pir

install-src:
	install -D lib/Form/TextFormatting.pm ~/.perl6/lib/Form/TextFormatting.pm
	install -D lib/Form/NumberFormatting.pm ~/.perl6/lib/Form/NumberFormatting.pm
	install -D lib/Form/Field.pm ~/.perl6/lib/Form/Field.pm
	install -D lib/Form/Actions.pm ~/.perl6/lib/Form/Actions.pm
	install -D lib/Form/Grammar.pm ~/.perl6/lib/Form/Grammar.pm
	install -D lib/Test.pm ~/.perl6/lib/Test.pm
	install -D lib/Form.pm ~/.perl6/lib/Form.pm
