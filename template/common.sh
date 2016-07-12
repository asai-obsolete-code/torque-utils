
[[ $WORLD_HOME == "" ]] && exit 1

. $WORLD_HOME/util/util.sh

gen (){
    # dry $@
    generate-qsub-templates.sh $@ || exit 1
    echo "run-notrun $expected_conf $root/$s*-$(name)-*"
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

export base="mwup-bin --megabytes-consed-between-gcs 100 -v"
export nocost="--remove-cost"

# planners
export lama2011="
--if-unit-cost
--heuristic hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))
--search lazy_greedy([hff,hlm],preferred=[hff,hlm])
--if-non-unit-cost
--heuristic hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))
--search lazy_greedy([hff1,hlm1],preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)
--always"

export lama="           --search fd-clean '$lama2011' -"

export lm="lmcut()"
export mn="merge_and_shrink(shrink_strategy=shrink_bisimulation(max_states=100000,threshold=1,greedy=false),merge_strategy=merge_dfp(),label_reduction=exact(before_shrinking=true,before_merging=false))"

export lmp="lmcut(cost_type=PLUSONE)"
export ffp="ff(cost_type=PLUSONE)"
export cep="cea(cost_type=PLUSONE)"
export gcp="goalcount(cost_type=PLUSONE)"
export mnp="merge_and_shrink(shrink_strategy=shrink_bisimulation(max_states=100000,threshold=1,greedy=false),merge_strategy=merge_dfp(),label_reduction=exact(before_shrinking=true,before_merging=false),cost_type=PLUSONE)"
export cgp="cg(cost_type=PLUSONE)"
export lcp="lmcount(lm_rhw(),cost_type=PLUSONE)"

export lmo="lmcut(cost_type=ONE)"
export ffo="ff(cost_type=ONE)"
export ceo="cea(cost_type=ONE)"
export gco="goalcount(cost_type=ONE)"
export mno="merge_and_shrink(shrink_strategy=shrink_bisimulation(max_states=100000,threshold=1,greedy=false),merge_strategy=merge_dfp(),label_reduction=exact(before_shrinking=true,before_merging=false),cost_type=ONE)"
export cgo="cg(cost_type=ONE)"
export lco="lmcount(lm_rhw(lm_cost_type=ONE,cost_type=ONE),cost_type=ONE)"


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
export test1="    -q agile  -m 2000000 -M 2000000 -t 60 -T 60"
export test2="    -q agile  -m 2000000 -M 2000000 -t 120 -T 120"
export test5="    -q agile  -m 2000000 -M 2000000 -t 300 -T 300"
export test5_4g="           -m 4000000 -M 4000000 -t 300 -T 300"
export test10="   -q agile  -m 2000000 -M 2000000 -t 600 -T 600"
export test20="             -m 2000000 -M 2000000 -t 1200 -T 1200"
export ipc="                -m 2000000 -M 2000000 -t 1800 -T 1800"
export ipc4g="              -m 4000000 -M 4000000 -t 1800 -T 1800"
export long="               -m 2000000 -M 2000000 -t 3600 -T 3600"
export long4g="             -m 4000000 -M 4000000 -t 3600 -T 3600"
export long16g="            -m 16000000 -M 16000000 -t 3600 -T 3600"
export iter16g="            -m 4000000 -M 16000000 -t 3600 -T 3600"
export learn="              -m 4000000 -M 4000000 -t 900 -T 900"

export mco=" -g /$(whoami) -u 1000000 -m 4000000 -M 4000000 -t 1800 -T 1800"

resources="test1 | test2 | test5 | test5_4g | test10 | test20 | ipc | long | learn"
