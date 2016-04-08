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

sets="ipc2011 ipc200x ipc2014"
sets="ipc2011 ipc2014"
expected_conf="ipc4g"

echo "#!/bin/bash"

for search in eager lazy ; do
    for s in $sets ; do
        for h in ce1 cg1 ff1 ; do
            for q in LIFO ; do
                # name=${h}${search}g
                # gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                #     "'$search(single(h,queue_type=$q))'" -
                # echo "run $expected_conf results/$s*-$name-*"

                name=${h}${search}G
                gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                    "'$search(typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q))'" -
                echo "run $expected_conf results/$s*-$name-*"
                
                name=${h}${search}gt
                gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                    "'$search(alt([single(h,queue_type=$q),typed_tiebreaking([],[g(),h],stochastic=false,queue_type=$q)]))'" -
                echo "run $expected_conf results/$s*-$name-*"
                # name=${h}${search}gT
                # gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                #     "'$search(alt([single(h,queue_type=$q),typed_tiebreaking([],[g(),h,depth([h])],stochastic=false,queue_type=$q)]))'" -
                # echo "run $expected_conf results/$s*-$name-*"
                name=${h}${search}Gt
                gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                    "'$search(alt([typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q),typed_tiebreaking([],[g(),h],stochastic=false,queue_type=$q)]))'" -
                echo "run $expected_conf results/$s*-$name-*"
                # name=${h}${search}GT
                # gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                #     "'$search(alt([typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q),typed_tiebreaking([],[g(),h,depth([h])],stochastic=false,queue_type=$q)]))'" -
                # echo "run $expected_conf results/$s*-$name-*"

                # name=${h}${search}rd
                # gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                #     "'$search(typed_tiebreaking([h],[depth([h])]))'" -
                # echo "run $expected_conf results/$s*-$name-*"
                # name=${h}${search}eg
                # gen -s $s -n $name $base $plain --search fd-clean --heuristic "'h=$(ref $h)'" --search \
                #     "'$search(epsilon_greedy([h]))'" -
                # echo "run $expected_conf results/$s*-$name-*"

            done
        done
    done
done

