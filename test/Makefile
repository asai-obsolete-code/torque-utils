
.SECONDEXPANSION:

# subdirs = $(shell ls -d $(1)/*/)
# $(info $(call subdirs,.))
# all:


dirs_set = $(shell ls -d */)
dirs_domain = $(shell ls -d */*/)

targets_set = $(foreach dir,$(dirs_set),$(dir)sstat)
targets_domain = $(foreach dir,$(dirs_domain),$(dir)dstat)

all: per-domain-results per-set-results

per-domain-results: $(targets_domain) ./per-domain.sh Makefile
	./per-domain.sh | cat - $(targets_domain) | column -t > $@

per-set-results: $(targets_set) ./per-set.sh Makefile
	./per-set.sh | cat - $(targets_set) | column -t > $@

%/dstat: $$(wildcard %/*.out) per-domain.sh Makefile
	./per-domain.sh $(dir $@) > $@

%/sstat: $$(wildcard %/*/*.out) per-set.sh Makefile
	./per-set.sh $(dir $@) > $@

