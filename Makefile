
.PHONY: all img preview .table

.SUFFIXES: %.ros
.PRECIOUS: %.depend %.make

all: aflab-303cluster mwup


%: Makefile

aflab-303cluster:
	git clone "git@github.com:guicho271828/aflab-303cluster.git"

mwup:
	git clone "git@github.com:guicho271828/mwup.git"
	make -C mwup
	ln -s mwup/mwup
