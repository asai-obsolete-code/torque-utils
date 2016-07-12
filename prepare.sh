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
root="new-bond"
echo "#!/bin/bash"

for search in eager lazy ; do
    for s in $sets ; do
        for h in ad1 ce1 cg1 ff1 ; do
            for q in FIFO LIFO RANDOM ; do
                # name=$h-$search-$q-h ; {
                #     : gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(single(h,queue_type=$q))'" -
                #     : echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                # name=$h-$search-$q-hd ; {
                #     : gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q))'" -
                #     : echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                name=$h-$search-$q-hr ; {
                    gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 \
                        --heuristic "'r=random()'" --heuristic "'h=$(ref $h)'" --search \
                        "'$search(tiebreaking([h,r],queue_type=$q))'" -
                    echo "run-notrun $expected_conf $root/$s*-$name-*"
                }
                # name=$h-$search-$q-hR ; {
                #     gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 \
                #         --heuristic "'r=random(threshold=0.8)'" --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(tiebreaking([h,r],queue_type=$q))'" -
                #     echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                name=$h-$search-$q-hb ; {
                    gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 \
                        --heuristic "'h=$(ref $h)'" --search \
                        "'$search(tiebreaking([h,random_edge_xor()],queue_type=$q))'" -
                    echo "run-notrun $expected_conf $root/$s*-$name-*"
                }
                # name=$h-$search-$q-hB ; {
                #     gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 \
                #         --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(tiebreaking([h,random_edge_xor(threshold=0.8)],queue_type=$q))'" -
                #     echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                # name=$h-$search-$q-hrd ; {
                #     gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 \
                #         --heuristic "'r=random()'" --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(typed_tiebreaking([h,r],[depth([h])],stochastic=false,queue_type=$q))'" -
                #     echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
                # name=$h-$search-$q-hdhr ; {
                #     gen -s $s -r $root -n $name $base $plain --search cached-fd-clean5 \
                #         --heuristic "'r=random()'" --heuristic "'h=$(ref $h)'" --search \
                #         "'$search(alt([tiebreaking([h,r],queue_type=$q),typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q)]))'" -
                #     echo "run-notrun $expected_conf $root/$s*-$name-*"
                # }
            done
        done
    done
done

