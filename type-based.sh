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

ff1="ff(cost_type=one)"
ad1="add(cost_type=one)"
ce1="cea(cost_type=one)"
gc1="goalcount(cost_type=one)"
cg1="cg(cost_type=one)"
lc1="lmcount(lm_rhw(),cost_type=one)"

sets="ipc2008-sat ipc2011-sat ipc2014-sat"
expected_conf="ipc4g"
root="std"
echo "#!/bin/bash"

for search in eager lazy ; do
    for s in $sets ; do
        for h in ad1 ce1 cg1 ff1 ; do
            for q in FIFO LIFO RANDOM ; do
                # name=$h-$search-$q-htd ; {
                #     gen -s $s -r $root -n $name $base $plain --search cached-fd-clean --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(alt([single(h,queue_type=$q),typed_tiebreaking([],[g(),h,depth([h])],stochastic=false,queue_type=$q)]))'" -
                #     echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                # name=$h-$search-$q-hdt ; {
                #     gen -s $s -r $root -n $name $base $plain --search cached-fd-clean --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(alt([typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q),typed_tiebreaking([],[g(),h],stochastic=false,queue_type=$q)]))'" -
                #     echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                # name=$h-$search-$q-hdtd ;{
                #     gen -s $s -r $root -n $name $base $plain --search cached-fd-clean --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(alt([typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q),typed_tiebreaking([],[g(),h,depth([h])],stochastic=false,queue_type=$q)]))'" -
                #     echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                name=$h-$search-$q-hrt ; {
                    gen -s $s -r $root -n $name $base $plain --search cached-fd-clean --heuristic "'h=$(ref $h)'" --heuristic "'r=random()'" --search \
                        "'$search(alt([tiebreaking([h,r],queue_type=$q),typed_tiebreaking([],[g(),h],stochastic=false,queue_type=$q)]))'" -
                    echo "run-notrun $expected_conf $root/$s*-$name-*"
                }
            done
        done
    done
done

