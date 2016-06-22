#!/bin/bash

. $WORLD_HOME/template/common.sh

lm="lmcut()"
mn="merge_and_shrink(shrink_strategy=shrink_bisimulation(max_states=100000,threshold=1,greedy=false),merge_strategy=merge_dfp(),label_reduction=label_reduction(before_shrinking=true,before_merging=false))"
ff="ff()"
ad="add()"
ce="cea()"
gc="goalcount()"
cg="cg()"
lc="lmcount(lm_rhw())"

lm1="lmcut(cost_type=one)"
ff1="ff(cost_type=one)"
ad1="add(cost_type=one)"
ce1="cea(cost_type=one)"
gc1="goalcount(cost_type=one)"
cg1="cg(cost_type=one)"
lc1="lmcount(lm_rhw(),cost_type=one)"
bl1="blind(cost_type=one)"

sets="ipc2008-opt ipc2011-opt ipc2014-opt"
expected_conf="test5_4g"

echo "#!/bin/bash"

for s in $sets ; do
    for h in probe mp ; do
        for length in 2 5 8 ; do
            name=${h} ; root=fig3-$length ; {
		gen -s $s -r $root -n $name $base --junk-type :relative-greedy --junk $length 1 \
                    --search $h-clean -
		echo "run-unsolved $expected_conf $root/$s*-$name-*"
	    }
        done
    done
done
