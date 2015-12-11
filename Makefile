
.PHONY: all img preview .table

.SUFFIXES: %.ros
.PRECIOUS: %.depend %.make

all: aflab-303cluster mwup-bin


%: Makefile

aflab-303cluster:
	git clone "git@github.com:guicho271828/aflab-303cluster.git"

mwup:
	git clone "git@github.com:guicho271828/mwup.git"

mwup-bin: mwup
	make -C mwup
	ln -s mwup/mwup ./mwup-bin

clean:
	rm -r mwup*
