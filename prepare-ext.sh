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

lamag (){
    root=lama; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,g()],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}

lamar (){
    root=lamar ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'r=random()'" \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,r],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamard; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([typed_tiebreaking([hff1,mod(random(),2)],[depth([hff1])],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamatr ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'r=random()'" \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,r],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}
main (){
    root=lama; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([single(hff1,queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    # root=lamad; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([$(ld hff1 false $q),$(sp hff1),single(hlm1),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    # root=lamab ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    # root=lamaB ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([single(hff1,queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),single(random_edge(),queue_type=RANDOM)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    root=lamat; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([single(hff1,queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}

lamaplus (){
    root=lamad+; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([$(ld hff1 false $q),$(sp hff1),$(ld hlm1 false $q),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamab+; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}

lamacombined2 (){
    root=lamaBd ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([$(ld hff1 false $q),$(sp hff1),single(hlm1),$(sp hlm1),single(random_edge(),queue_type=RANDOM)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamaBb ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),single(random_edge(),queue_type=RANDOM)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamatd; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([$(ld hff1 false $q),$(sp hff1),single(hlm1),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamatb ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}

lamacombined3 (){
    root=lamaBtd ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([$(ld hff1 false $q),$(sp hff1),single(hlm1),$(sp hlm1),single(random_edge(),queue_type=RANDOM),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamatrd; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([typed_tiebreaking([hff1,mod(random(),2)],[depth([hff1])],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamatbd; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([typed_tiebreaking([hff1,mod(random_edge(),2)],[depth([hff1])],queue_type=$q),$(sp hff1),single(hlm1),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}

lamacombined2plus (){
    # root=lamaBd+ ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([$(ld hff1 false $q),$(sp hff1),$(ld hlm1 false $q),$(sp hlm1),single(random_edge(),queue_type=RANDOM)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    # root=lamaBb+ ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1),single(random_edge(),queue_type=RANDOM)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    # root=lamatd+; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([$(ld hff1 false $q),$(sp hff1),$(ld hlm1 false $q),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    # root=lamatb+ ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    # root=lamaBdb+ ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([$(ld hff1 false $q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1),single(random_edge(),queue_type=RANDOM)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    root=lamaBbd+ ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),$(ld hlm1 false $q),$(sp hlm1),single(random_edge(),queue_type=RANDOM)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamatdb+; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([$(ld hff1 false $q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamatbd+ ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),$(ld hlm1 false $q),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}

lamacombined4plus (){
    root=lamab ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamad ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([$(ld hff1 false $q),$(sp hff1),$(ld hlm1 false $q),$(sp hlm1)]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamaB ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([single(hff1,queue_type=$q),$(sp hff1),single(hlm1,queue_type=$q),$(sp hlm1),single(random_edge())]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamaD ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([single(hff1,queue_type=$q),$(sp hff1),single(hlm1,queue_type=$q),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamabB ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([tiebreaking([hff1,random_edge()],queue_type=$q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1),single(random_edge())]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    root=lamadD ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([$(ld hff1 false $q),$(sp hff1),$(ld hlm1 false $q),$(sp hlm1),type_based([g(),hff1])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
    # root=lamadbDB ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([$(ld hff1 false $q),$(sp hff1),tiebreaking([hlm1,random_edge()],queue_type=$q),$(sp hlm1),alt([type_based([g(),hff1]),single(random_edge())])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
    # root=lamadbdbDB ; {
    #     gen -s $s -r $root -n $(name) $base $plain --search $driver \
    #         --random-seed $seed \
    #         --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
    #         --search \
    #         "'lazy(alt([alt([$(ld hff1 false $q),tiebreaking([hff1,random_edge()],queue_type=$q)]),$(sp hff1),alt([$(ld hlm1 false $q),tiebreaking([hlm1,random_edge()],queue_type=$q)]),$(sp hlm1),alt([type_based([g(),hff1]),single(random_edge())])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    # }
}

lamaless (){
    root=dbdbDB ; {
        gen -s $s -r $root -n $(name) $base $plain --search $driver \
            --random-seed $seed \
            --heuristic "'hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))'" \
            --search \
            "'lazy(alt([alt([$(ld hff1 false $q),tiebreaking([hff1,random_edge()],queue_type=$q)]),alt([$(ld hlm1 false $q),tiebreaking([hlm1,random_edge()],queue_type=$q)]),alt([type_based([g(),hff1]),single(random_edge())])]),preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)'" -
    }
}


first=true

main2 (){
    seed=$RANDOM
    (
        for s in $sets ; do
            for q in FIFO ; do
                # lamacombined2plus
                lamaless
                # main
            done
        done
    ) >> $(if $first ; then echo /dev/fd/1 ; else echo /dev/fd/2 ; fi)
    first=false
}

for i in {1..1} ; do
    main2
done
