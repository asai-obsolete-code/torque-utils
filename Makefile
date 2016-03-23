
.PHONY: submodules

all: mwup-bin

submodules:
	git submodule update --init --recursive --remote

mwup-bin: submodules
	$(MAKE) -C mwup
	ln -s mwup/mwup ./mwup-bin

clean:
	rm -rf mwup*
