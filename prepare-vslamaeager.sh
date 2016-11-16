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

sets="ipc2011 ipc200x ipc2014"
expected_conf="test20"


ld (){
    echo "typed_tiebreaking([$1],[depth([$1])],stochastic=false,pref_only=${2:-false})"
}

echo "#!/bin/bash"

for s in $sets ; do
    name=elameg
    gen -s $s -n $name $base $plain --search fd-clean \
        --if-unit-cost \
        --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
        --search "'eager(alt([single(hff),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true)]),preferred=[hff,hlm])'" \
        --if-non-unit-cost \
        --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
        --search "'eager(alt([single(hff1),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
        --always -
    echo "run $expected_conf results/$s*-$name-*"

    # name=elamld
    # gen -s $s -n $name $base $plain --search fd-clean \
    #     --if-unit-cost \
    #     --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
    #     --search \
    #     "'eager(alt([$(ld hff),$(ld hff true),$(ld hlm),$(ld hlm true)]),preferred=[hff,hlm])'" \
    #     --if-non-unit-cost \
    #     --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #     --search \
    #     "'eager(alt([$(ld hff1),$(ld hff1 true),$(ld hlm1),$(ld hlm1 true)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
    #     --always -
    # echo "run $expected_conf results/$s*-$name-*"
    name=elamtp
    gen -s $s -n $name $base $plain --search fd-clean \
        --if-unit-cost \
        --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
        --search "'eager(alt([single(hff),single(hff,pref_only=true),single(hlm),single(hlm,pref_only=true),type_based([g(),hff])]),preferred=[hff,hlm])'" \
        --if-non-unit-cost \
        --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
        --search "'eager(alt([single(hff1),single(hff1,pref_only=true),single(hlm1),single(hlm1,pref_only=true),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
        --always -
    echo "run $expected_conf results/$s*-$name-*"
    # name=elamtd
    # gen -s $s -n $name $base $plain --search fd-clean \
    #     --if-unit-cost \
    #     --heuristic "'hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))'" \
    #     --search "'eager(alt([$(ld hff),$(ld hff true),$(ld hlm),$(ld hlm true),type_based([g(),hff])]),preferred=[hff,hlm])'" \
    #     --if-non-unit-cost \
    #     --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #     --search "'eager(alt([$(ld hff1),$(ld hff1 true),$(ld hlm1),$(ld hlm1 true),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" \
    #     --always -
    # echo "run $expected_conf results/$s*-$name-*"
done

