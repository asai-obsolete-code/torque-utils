
[[ $WORLD_HOME == "" ]] && exit 1

. $WORLD_HOME/util/util.sh

gen (){
    # dry $@
    generate-qsub-templates.sh $@ || exit 1
}

dry (){
    echo "generate-qsub-templates.sh $@"
}

export SEED=$RANDOM

# configs
export lift="--force-lifted"
export iter="--iterated"
export macrocost="--add-macro-cost"
export plain="--plain"

export base="mwup-bin -v --megabytes-consed-between-gcs 100"
export nocost="--remove-cost"

# planners
export lama2011="
--search-options
--if-unit-cost
--heuristic hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))
--search lazy_greedy([hff,hlm],preferred=[hff,hlm])
--if-non-unit-cost
--heuristic hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))
--search lazy_greedy([hff1,hlm1],preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)
--always"

export lama="           --search fd-clean '$lama2011' -"
export lmcut="          --search fd-clean --search 'astar(lmcut())' -"
export lmcut_greedy="   --search fd-clean --search 'eager_greedy(lmcut())' -"
export lmcut_lazy_greedy="   --search fd-clean --search 'lazy_greedy(lmcut())' -"
blind (){
    echo "--search fd-clean --heuristic 'h=blind()' --search 'eager(tiebreaking([sum([g(),h]),h]),bound=$((1+$1)))' -"
}
export -f blind

mands_h="--heuristic 'h=merge_and_shrink(shrink_strategy=shrink_bisimulation(max_states=100000,threshold=1,greedy=false),merge_strategy=merge_dfp(),label_reduction=label_reduction(before_shrinking=true,before_merging=false))'"
export mands="          --search fd-clean $mands_h --search 'astar(h)'"
export mands_greedy="   --search fd-clean $mands_h --search 'eager_greedy(h)' -"




# CAP configs
{
export ff="     $nocost --search ff-clean -"
export probe="          --search probe-clean -"
export mv="     $nocost --search marvin2-clean -"
export mv1="    $nocost --search marvin1-clean -"
export lpg="    $nocost --search lpg-clean -"

export m="              --search m-clean -"
export mp="             --search mp-clean -"
export mpc="            --search mpc-clean -"

export yh="   --search yahsp3-clean -"
export mc="   --search mercury-clean -"
export ja="   --search jasper-clean -"

# export solep="  $nocost --search solep-clean - $trainings"
# export trainings="--training t01.pddl --training t02.pddl --training t03.pddl"
}

export nil=""

gen=gen


# this requires /asai cgroup
export test1=" -q agile -g /$(whoami) -m 2000000 -M 2000000 -t 60 -T 60       -n 1:fun"
export test2=" -q agile -g /$(whoami) -m 2000000 -M 2000000 -t 120 -T 120     -n 1:fun"
export test5=" -g /$(whoami) -m 2000000 -M 2000000 -t 300 -T 300              -n 1:fun"
export test5_4g=" -q batch -g /$(whoami) -m 4000000 -M 4000000 -t 300 -T 300  -n 1:fun"
export test10="-q batch -g /$(whoami) -m 2000000 -M 2000000 -t 600 -T 600     -n 1:fun"
export test20="-g /$(whoami) -m 2000000 -M 2000000 -t 1200 -T 1200            -n 1:fun"
export ipc="   -g /$(whoami) -m 2000000 -M 2000000 -t 1800 -T 1800            -n 1:fun"
export ipcmicro="   -g /$(whoami) -m 2000000 -M 2000000 -t 1800 -T 1800            -n 1:micro"
export ipc4g="   -g /$(whoami) -m 4000000 -M 4000000 -t 1800 -T 1800          -n 1:fun"
export long="   -g /$(whoami) -m 2000000 -M 2000000 -t 14400 -T 14400         -n 1:fun"
export longiter="   -g /$(whoami) -m 2000000 -M 16000000 -t 14400 -T 14400    -n 1:fun"
export longiterall="   -g /$(whoami) -m 2000000 -M 16000000 -t 14400 -T 14400 "
export long16g=" -g /$(whoami) -m 16000000 -M 16000000 -t 3600 -T 3600        -n 1:fun"
export doubling16g=" -g /$(whoami) -m 500000 -M 16000000 -t 3600 -T 3600      -n 1:fun"
export learn=" -g /$(whoami) -m 4000000 -M 4000000 -t 900 -T 900              -n 1:fun"

export mco=" -g /$(whoami) -u 1000000 -m 4000000 -M 4000000 -t 1800 -T 1800"

resources="test1 | test2 | test5 | test5_4g | test10 | test20 | ipc | long | learn"
