MAINS = $(shell find . -maxdepth 3 -type f -name main.tex)

PDFS = $(MAINS:.tex=.pdf)

all: doc

doc: $(PDFS)

$(PDFS): %.pdf: $(dir %)/*.tex
	lualatex main.tex || echo "error"
	bibtex main
	lualatex main.tex || echo "error"
	lualatex main.tex || echo "error"

handout.pdf: handout.tex
	lualatex handout.tex
	bibtex handout
	lualatex handout.tex
	lualatex handout.tex

main43.pdf: main43.tex
	lualatex main43.tex
	bibtex main43
	lualatex main43.tex
	lualatex main43.tex

handout.tex: main.tex
	cat main.tex | sed 's/\\documentclass\[/\\documentclass[handout,/' > handout.tex

main43.tex: main.tex
	cat main.tex | sed 's/aspectratio=169/aspectratio=43/' > main43.tex

beamer.tex:
	if hue; then sed -i \
			-e "s/mDarkBrown.*/mDarkBrown\}\{RGB\}{$$(hue .18 .81 --format '{r}, {g}, {b}')}/" \
			-e "s/mDarkTeal.*/mDarkTeal\}\{RGB\}{$$(hue .18 .81 --format '{r}, {g}, {b}')}/" \
			-e "s/mLightBrown.*/mLightBrown\}\{RGB\}{$$(hue .9 --format '{r}, {g}, {b}')}/" \
			-e "s/mLightGreen.*/mLightGreen\}\{RGB\}{$$(hue .9 --format '{r}, {g}, {b}')}/" \
		beamer.tex; fi


purge:
	rm $(MAINS:.tex=.fls) || echo "fine"
	rm $(MAINS:.tex=.ist) || echo "fine"
	rm $(MAINS:.tex=.aux) || echo "fine"
	rm $(MAINS:.tex=.fdb_latexmk) || echo "fine"
	rm $(MAINS:.tex=.log) || echo "fine"
	rm $(MAINS:.tex=.lol) || echo "fine"
	rm $(MAINS:.tex=.out) || echo "fine"

clean: purge
	rm $(MAINS:.tex=.pdf) || echo "fine"

.PHONY: all purge clean beamer.tex
