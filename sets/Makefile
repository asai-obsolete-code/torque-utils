
targets = ipc2008-sat ipc2011-sat ipc2014-sat ipc2008-opt ipc2011-opt ipc2014-opt ipc2006-optsat zerocost-opt aaai16-opt

default: help

help:
	@echo possible targets:
	@(for x in $(targets) ; do echo $$x ; done)
	@echo all --- all of them

all: $(targets)

%:
	git clone https://github.com/guicho271828/$@.git

