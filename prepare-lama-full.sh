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
bl1="blind(cost_type=one)"

sets="ipc2011-sat ipc2014-sat"
expected_conf="test5_4g"
driver=fd-clean
echo "#!/bin/bash"
sp (){
    echo "single($1,pref_only=true)"
}

ld (){
    echo "typed_tiebreaking([$1],[depth([$1])],pref_only=${2:-false},queue_type=$3)"
}
name (){
    echo $h-$search-$q-$root
}
repeat (){
    n=$1
    delimiter=$2
    echo -n $3
    for ((i=0;i<n;i++))
    do
        echo -n $delimiter$3
    done
}

main (){
    root=lama; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([single(hff1,queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamat; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([single(hff1,queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}

first=true

main2 (){
    seed=$RANDOM
    (
        for s in $sets ; do
            for q in FIFO ; do
                main
            done
        done
    ) >> $(if $first ; then echo /dev/fd/1 ; else echo /dev/fd/2 ; fi)
    first=false
}

for i in {1..4} ; do
    main2
done
