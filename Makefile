
.PHONY: all img preview .table

.SUFFIXES: %.ros
.PRECIOUS: %.depend %.make

tracks := aaai16prelim3 zerocost 2zerocost

all: component-planner preview aflab-303cluster

%: Makefile

aflab-303cluster:
	git clone "git@github.com:guicho271828/aflab-303cluster.git"

.summarize: $(wildcard summarize/*)
	$(MAKE) -C summarize
	touch .summarize

%/all.summary: $(wildcard %/*/*.out) .summarize
	summarize/summarize $(dir $@)

.results: .summarize $(foreach d,$(wildcard results/*),$(d)/all.summary)
	touch .results

component-planner:
	-$(MAKE) -C CAP
	-ln -s CAP/component-planner

comma:= ,
empty:=
space:= $(empty) $(empty)

multi_dir = output/$(subst $(space),_,$(tracks))
single_dirs = $(foreach t,$(tracks),output/$(t))
get_tracks = $(subst _, ,$(patsubst output/%/,%,$(dir $(1))))
modes = $(basename $(notdir $(wildcard table/*.ros)))
single_targets = $(foreach d,$(single_dirs),$(foreach m,$(modes),$(d)/$(m).tex))
multi_targets = $(foreach m,$(modes),$(multi_dir)/$(m).tex)

$(info $(modes))
$(info $(tracks))
$(info $(single_dirs))
$(info $(multi_dir))
# $(info $(single_targets))
# $(info $(multi_targets))
$(info ------------------------)

ros = table/$(basename $(notdir $(1))).ros
rosargs = $(foreach t,$(call get_tracks,$(1)),"\"results/$(t)*/all.summary\"")
rosargs_expanded = $(foreach t,$(call get_tracks,$(1)),results/$(t)*/all.summary)

%.make: Makefile
	mkdir -p $(dir $@)
	echo "$*.tex: $(call ros,$*.tex) $(wildcard table/*.lisp) $(call rosargs_expanded,$*.tex) Makefile; $(call ros,$*.tex) $(call rosargs,$*.tex) > $*.tex" > $@

%.tex: %.make $(wildcard table/*.lisp) $(wildcard table/*.ros) .results Makefile 
	mkdir -p $(dir $@)
	make -f $< $@

clean:
	-rm -rf output

distclean: clean
	-rm .table
	-$(MAKE) -C table clean
	-$(MAKE) -C summarize clean

preview: .results $(single_targets) $(multi_targets)
	app/preview $(multi_targets)

