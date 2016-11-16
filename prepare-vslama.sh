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

sets="ipc2008-sat ipc2011-sat ipc2014-sat"
expected_conf="ipc4g"
root=lama
ld (){
    echo "typed_tiebreaking([$1],[depth([$1])],pref_only=${2:-false},queue_type=$3)"
}

h=fflm
search=lama


echo "#!/bin/bash"

for i in {1..3} ; do
    seed=$RANDOM
    root=lama$seed
    for s in $sets ; do
        for q in RANDOM ; do
            name=lama-fflm-$q-h ; {
                gen -s $s -n $name -r $root$ $base $plain --search cached-fd-clean --random-seed $seed \
                    --if-unit-cost \
                    --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
                    --search \
                    "'lazy(alt([single(hff,queue_type=$q),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true)]),preferred=[hff,hlm])'" \
                    --if-non-unit-cost \
                    --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
                    --search \
                    "'lazy(alt([single(hff1,queue_type=$q),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
                    --always -
                echo "run-notrun $expected_conf $root/$s*-$name-*"
            }
            name=lama-fflm-$q-hd ; {
                gen -s $s -n $name -r $root $base $plain --search cached-fd-clean --random-seed $seed \
                    --if-unit-cost \
                    --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
                    --search \
                    "'lazy(alt([$(ld hff false $q),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true)]),preferred=[hff,hlm])'" \
                    --if-non-unit-cost \
                    --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
                    --search \
                    "'lazy(alt([$(ld hff1 false $q),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
                    --always -
                echo "run-notrun $expected_conf $root/$s*-$name-*"
            }
            name=lama-fflm-$q-hr ; {
                gen -s $s -n $name -r $root $base $plain --search cached-fd-clean --random-seed $seed \
                    --if-unit-cost \
                    --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
                    --heuristic "'r=random()'" \
                    --search \
                    "'lazy(alt([tiebreaking([hff,r],queue_type=$q),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true)]),preferred=[hff,hlm])'" \
                    --if-non-unit-cost \
                    --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
                    --heuristic "'r=random()'" \
                    --search \
                    "'lazy(alt([tiebreaking([hff1,r],queue_type=$q),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
                    --always -
                echo "run-notrun $expected_conf $root/$s*-$name-*"
            }
            name=lama-fflm-$q-ht ; {
                gen -s $s -n $name -r $root $base $plain --search cached-fd-clean --random-seed $seed \
                    --if-unit-cost \
                    --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
                    --search "'lazy(alt([single(hff),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true),type_based([g(),hff])]),preferred=[hff,hlm])'" \
                    --if-non-unit-cost \
                    --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
                    --search "'lazy(alt([single(hff1),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
                    --always -
                echo "run-notrun $expected_conf $root/$s*-$name-*"
            }
            name=lama-fflm-$q-hdt ; {
                gen -s $s -n $name -r $root $base $plain --search cached-fd-clean --random-seed $seed \
                    --if-unit-cost \
                    --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
                    --search "'lazy(alt([$(ld hff false $q),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true),type_based([g(),hff])]),preferred=[hff,hlm])'" \
                    --if-non-unit-cost \
                    --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
                    --search "'lazy(alt([$(ld hff1 false $q),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
                    --always -
                echo "run-notrun $expected_conf $root/$s*-$name-*"
            }
            name=lama-fflm-$q-hrt ; {
                gen -s $s -n $name -r $root $base $plain --search cached-fd-clean --random-seed $seed \
                    --if-unit-cost \
                    --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
                    --heuristic "'r=random()'" \
                    --search "'lazy(alt([tiebreaking([hff,r],queue_type=$q),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true),type_based([g(),hff])]),preferred=[hff,hlm])'" \
                    --if-non-unit-cost \
                    --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
                    --heuristic "'r=random()'" \
                    --search "'lazy(alt([tiebreaking([hff1,r],queue_type=$q),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
                    --always -
                echo "run-notrun $expected_conf $root/$s*-$name-*"
            }
            name=lama-fflm-$q-hrdt ; {
                gen -s $s -n $name -r $root $base $plain --search cached-fd-clean --random-seed $seed \
                    --if-unit-cost \
                    --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
                    --heuristic "'r=random()'" \
                    --search "'lazy(alt([typed_tiebreaking([hff,r],[depth([hff])],queue_type=$q),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true),type_based([g(),hff])]),preferred=[hff,hlm])'" \
                    --if-non-unit-cost \
                    --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
                    --heuristic "'r=random()'" \
                    --search "'lazy(alt([typed_tiebreaking([hff1,r],[depth([hff1])],queue_type=$q),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
                    --always -
                echo "run-notrun $expected_conf $root/$s*-$name-*"
            }
        done
    done
done
