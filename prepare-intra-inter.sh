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
expected_conf="ipc4g"
driver=cached-fd-clean3
echo "#!/bin/bash"

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
    # root=h; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(single(h,queue_type=$q))'" -
    # }
    # root=hd; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q))'" -
    # }
    # root=hr ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'r=random()'" --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(tiebreaking([h,r],queue_type=$q))'" -
    # }
    # root=hb ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(tiebreaking([h,random_edge()],queue_type=$q))'" -
    # }
    root=hg ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'h=$(ref $h)'" --search \
            "'$search(alt([single(h,queue_type=$q),type_based([g],queue_type=RANDOM)]))'" -
    }
    # root=hT ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(alt([single(h,queue_type=$q),type_based([h],queue_type=RANDOM)]))'" -
    # }
    # root=ht ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(alt([single(h,queue_type=$q),type_based([h,g()],queue_type=RANDOM)]))'" -
    # }
    # root=hR ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'r=random()'" --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(alt([single(h,queue_type=$q),single(r,queue_type=RANDOM)]))'" -
    # }
    # root=hB ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(alt([single(h,queue_type=$q),single(random_edge(),queue_type=RANDOM)]))'" -
    # }
    # root=hrd ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --heuristic "'r=random()'" --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(typed_tiebreaking([h,r],[depth([h])],stochastic=false,queue_type=$q))'" -
    # }
    # root=hdhr ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --heuristic "'r=random()'" --heuristic "'h=$(ref $h)'" --search \
    #         "'$search(alt([tiebreaking([h,r],queue_type=$q),typed_tiebreaking([h],[depth([h])],stochastic=false,queue_type=$q)]))'" -
    # }
    # root=hR ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'iterated([$(repeat 5 "," "$search(tiebreaking([h,random(threshold=0.8)],queue_type=$q))")],repeat_last=true,continue_on_fail=true,continue_on_solve=false)'" -
    # }
    # root=hB ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'h=$(ref $h)'" --search \
    #         "'iterated([$(repeat 5 "," "$search(tiebreaking([h,random_edge(threshold=0.8)],queue_type=$q))")],repeat_last=true,continue_on_fail=true,continue_on_solve=false)'" -
    # }
}

first=true

main2 (){
    seed=$RANDOM
    (
        for search in eager ; do
            for s in $sets ; do
                for q in FIFO ; do
                    for h in cg1 ff1 ; do
                        driver=cached-fd-clean3 main
                    done
                done
            done
        done
    ) >> $(if $first ; then echo /dev/fd/1 ; else echo /dev/fd/2 ; fi)
    first=false
}

for i in {1..4} ; do
    main2
done