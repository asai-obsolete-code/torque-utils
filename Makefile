
.PHONY: submodules

all: submodules
	@echo "For other binaries, run follows:"
	@echo "mwup : make mwup-bin"
	@echo "CAP  : make CAP"

submodules:
	git submodule update --init --recursive --remote

mwup-bin:
	git clone https://github.com/guicho271828/mwup.git
	$(MAKE) -C mwup
	ln -s mwup/mwup ./mwup-bin

CAP:
	git clone https://github.com/guicho271828/CAP.git
	$(MAKE) -C CAP
	ln -s CAP/component-planner .

clean:
	rm -rf mwup*
