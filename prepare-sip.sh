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
driver=cached-fd-clean5
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
   root=hs ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'h=$(ref $h)'" --search \
            "'$search(tiebreaking([h,random()],queue_type=$q))'" -
    }
    root=hS ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'h=$(ref $h)'" --search \
            "'$search(alt([single(h,queue_type=$q),single(random(),queue_type=RANDOM)]))'" -
    }
    root=hsS ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'h=$(ref $h)'" --search \
            "'$search(alt([tiebreaking([h,random()],queue_type=$q),single(random(),queue_type=RANDOM)]))'" -
    }
}

first=true

main2 (){
    seed=$RANDOM
    (
        for search in eager lazy ; do
            for s in $sets ; do
                for q in FIFO ; do
                    for h in cg1 ff1 ; do
                        main
                    done
                done
            done
        done
    ) >> $(if $first ; then echo /dev/fd/1 ; else echo /dev/fd/2 ; fi)
    first=false
}

for i in {1..10} ; do
    main2
done
