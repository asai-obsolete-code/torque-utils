
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
export cp="--compatibility"
export cy="--cyclic-macros"
export bin="--binarization"
export lift="--force-lifted"
export ca="--component-abstraction"
export iter="--iterated"
export macrocost="--add-macro-cost"
export plain="--plain"
export variable="--force-variable-factoring"

export tl30="--preprocess-limit 1800"
export tl15="--preprocess-limit 900"
export tl07="--preprocess-limit 450"
export tl05="--preprocess-limit 300"

export base="component-planner --dynamic-space-size 2000 -t 3600 -m 2000000 -v"
export base4g="component-planner --dynamic-space-size 4000 -t 3600 -m 4000000 -v"
export baselong16g="component-planner --dynamic-space-size 16000 -t 7200 -m 16000000 -v"
export nocost="--remove-component-problem-cost --remove-main-problem-cost"

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

export cea="            --both-search fd-clean --search 'lazy_greedy(cea())' -"
export lama="           --both-search fd-clean '$lama2011' -"
export lmcut="          --both-search fd-clean --search 'astar(lmcut())' -"

export purefd_astar="--both-search fd-clean --search 'astar(lmcut())' -"
export purefd_eager=" $lmc --search 'eager(tiebreaking([sum([g(),h]),h]),reopen_closed=true)' -"

# heuristics

lmc="--both-search fd-clean --heuristic 'h=lmcut()'"
blind="--both-search fd-clean --heuristic 'h=blind()'"
mands="--both-search fd-clean --heuristic 'h=merge_and_shrink(shrink_strategy=shrink_bisimulation(max_states=100000,threshold=1,greedy=false),merge_strategy=merge_dfp(),label_reduction=label_reduction(before_shrinking=true,before_merging=false))'"

# tiebreaking
{
    # no spaces allowed!
    # f,h
    {
        export fifo="eager(tiebreaking([sum([g(),h]),h]))"
        export lifo="eager(tiebreaking([sum([g(),h]),h],queue=1))"
        export random="eager(tiebreaking([sum([g(),h]),h],queue=2))"
        export rd_fifo="eager(rd([sum([g(),h]),h],queue=0))"
        export rd_lifo="eager(rd([sum([g(),h]),h],queue=1))"
        export rd_random="eager(rd([sum([g(),h]),h],queue=2))"
        export fd_fifo="eager(fd([sum([g(),h]),h],queue=0))"
        export fd_lifo="eager(fd([sum([g(),h]),h],queue=1))"
        export fd_random="eager(fd([sum([g(),h]),h],queue=2))"
        export ld_fifo="eager(ld([sum([g(),h]),h],queue=0))"
        export ld_lifo="eager(ld([sum([g(),h]),h],queue=1))"
        export ld_random="eager(ld([sum([g(),h]),h],queue=2))"

        export rd_randomx="eager(rd([sum([g(),h]),h],queue=2,seed2=$SEED,seed3=$SEED))"
        export fd_randomx="eager(fd([sum([g(),h]),h],queue=2,seed3=$SEED))"
        export ld_randomx="eager(ld([sum([g(),h]),h],queue=2,seed3=$SEED))"
        export randomx="eager(tiebreaking([sum([g(),h]),h],queue=2,seed=$SEED))"
    }
    # f
    {
        export fifo_noh="eager(tiebreaking([sum([g(),h])]))"
        export lifo_noh="eager(tiebreaking([sum([g(),h])],queue=1))"
        export random_noh="eager(tiebreaking([sum([g(),h])],queue=2))"
        export rd_fifo_noh="eager(rd([sum([g(),h])],queue=0))"
        export rd_lifo_noh="eager(rd([sum([g(),h])],queue=1))"
        export rd_random_noh="eager(rd([sum([g(),h])],queue=2))"
        export fd_fifo_noh="eager(fd([sum([g(),h])],queue=0))"
        export fd_lifo_noh="eager(fd([sum([g(),h])],queue=1))"
        export fd_random_noh="eager(fd([sum([g(),h])],queue=2))"
        export ld_fifo_noh="eager(ld([sum([g(),h])],queue=0))"
        export ld_lifo_noh="eager(ld([sum([g(),h])],queue=1))"
        export ld_random_noh="eager(ld([sum([g(),h])],queue=2))"

        export rd_randomx_noh="eager(rd([sum([g(),h])],queue=2,seed2=$SEED,seed3=$SEED))"
        export randomx_noh="eager(tiebreaking([sum([g(),h])],queue=2,seed=$SEED))"
    }
    export typed="eager(alt([tiebreaking([sum([g(),h]),h]),tiebreaking([sum([g(),h]),r])]))"
    export frontier="eager(tiebreaking([sum([g(),h]),h],frontier=true),complete_search=true)"
    export frontier_noh="eager(tiebreaking([sum([g(),h])],frontier=true),complete_search=true)"
 }
# combinations
{
    export lmcut_frontier=" $lmc --search '$frontier' -"
    export lmcut_frontier_noh=" $lmc --search '$frontier_noh' -"

    export lmcut_rdlog=" $lmc --search 'eager(rd([sum([g(),h]),h],queue=2,frontier=true))' -"
    export lmcut_ldlog=" $lmc --search 'eager(ld([sum([g(),h]),h],queue=2,frontier=true))' -"
    export lmcut_fdlog=" $lmc --search 'eager(fd([sum([g(),h]),h],queue=2,frontier=true))' -"
    export lmcut_ld_lifo_log=" $lmc --search 'eager(ld([sum([g(),h]),h],queue=1,frontier=true))' -"
    export lmcut_fd_fifo_log=" $lmc --search 'eager(fd([sum([g(),h]),h],queue=0,frontier=true))' -"
    export lmcut_rd_random_log=" $lmc --search 'eager(rd([sum([g(),h]),h],queue=2,frontier=true))' -"

    # lmcut
    {
        export lmcut_ff=" $lmc --search '$fifo' -"
        export lmcut_lf=" $lmc --search '$lifo' -"
        export lmcut_r="  $lmc   --search '$random' -"

        export lmcut_rd_fifo="  $lmc --search '$rd_fifo' -"
        export lmcut_rd_lifo="  $lmc --search '$rd_lifo' -"
        export lmcut_rd_random="$lmc --search '$rd_random' -"
        export lmcut_fd_fifo="  $lmc --search '$fd_fifo' -"
        export lmcut_fd_lifo="  $lmc --search '$fd_lifo' -"
        export lmcut_fd_random="$lmc --search '$fd_random' -"
        export lmcut_ld_fifo="  $lmc --search '$ld_fifo' -"
        export lmcut_ld_lifo="  $lmc --search '$ld_lifo' -"
        export lmcut_ld_random="$lmc --search '$ld_random' -"

        export lmcut_rx="  $lmc   --search '$randomx' -"
        export lmcut_rd_randomx="$lmc --search '$rd_randomx' -"
        export lmcut_fd_randomx="$lmc --search '$fd_randomx' -"
        export lmcut_ld_randomx="$lmc --search '$ld_randomx' -"
        export lmcut_rx_noh="  $lmc   --search '$randomx_noh' -"
        export lmcut_rd_randomx_noh="$lmc --search '$rd_randomx_noh' -"

        export lmcut_lf_noh=" $lmc --search '$lifo_noh' -"
        export lmcut_ff_noh=" $lmc --search '$fifo_noh' -"
        export lmcut_r_noh="$lmc --search '$random_noh' -"

        export lmcut_rd_fifo_noh="  $lmc --search '$rd_fifo_noh' -"
        export lmcut_rd_lifo_noh="  $lmc --search '$rd_lifo_noh' -"
        export lmcut_rd_random_noh="$lmc --search '$rd_random_noh' -"
        export lmcut_fd_fifo_noh="  $lmc --search '$fd_fifo_noh' -"
        export lmcut_fd_lifo_noh="  $lmc --search '$fd_lifo_noh' -"
        export lmcut_fd_random_noh="$lmc --search '$fd_random_noh' -"
        export lmcut_ld_fifo_noh="  $lmc --search '$ld_fifo_noh' -"
        export lmcut_ld_lifo_noh="  $lmc --search '$ld_lifo_noh' -"
        export lmcut_ld_random_noh="$lmc --search '$ld_random_noh' -"
        
        export lmcut_typed=" $lmc --search '$typed' -"

        # testing purpose
        export lmcut_ffff=" $lmc --search 'multi([$fifo,$fifo])' -"
        export lmcut_multi_ff=" $lmc --search 'multi([$fifo])' -"
        export lmcut_multi_zero=" $lmc --search 'multi([])' -"

        # multisearch
        export lmcut_m2="$lmc --search 'multi([$ld_random,$rd_lifo])' -"
        export lmcut_m3="$lmc --search 'multi([$ld_fifo,$ld_random,$rd_lifo])' -"
        export lmcut_m4="$lmc --search 'multi([$ld_fifo,$ld_random,$rd_lifo,$ld_lifo])' -"
        export lmcut_m5="$lmc --search 'multi([$ld_fifo,$ld_random,$fd_lifo,$rd_lifo,$ld_lifo])' -"

        export lmcut_ldrd_random="$lmc --search 'multi([$ld_random,$rd_random])' -"
        export lmcut_ldfd_random="$lmc --search 'multi([$ld_random,$fd_random])' -"
        export lmcut_fdrd_random="$lmc --search 'multi([$fd_random,$rd_random])' -"
        export lmcut_fdrdld_random="$lmc --search 'multi([$fd_random,ld_random,$rd_random])' -"

        # for tests
        export lmcut_ldldrdrd_random="$lmc --search 'multi([$ld_random,$ld_random,$rd_random,$rd_random])' -"
        export lmcut_ldrdldrd_random="$lmc --search 'multi([$ld_random,$rd_random,$ld_random,$rd_random])' -"




    }
    # mands
    {
        export mands_ff=" $mands --search '$fifo' -"
        export mands_lf=" $mands --search '$lifo' -"
        export mands_r="  $mands   --search '$random' -"

        export mands_rd_fifo="  $mands --search '$rd_fifo' -"
        export mands_rd_lifo="  $mands --search '$rd_lifo' -"
        export mands_rd_random="$mands --search '$rd_random' -"
        export mands_fd_fifo="  $mands --search '$fd_fifo' -"
        export mands_fd_lifo="  $mands --search '$fd_lifo' -"
        export mands_fd_random="$mands --search '$fd_random' -"
        export mands_ld_fifo="  $mands --search '$ld_fifo' -"
        export mands_ld_lifo="  $mands --search '$ld_lifo' -"
        export mands_ld_random="$mands --search '$ld_random' -"
 
        export mands_lf_noh=" $mands --search '$lifo_noh' -"
        export mands_ff_noh=" $mands --search '$fifo_noh' -"
        export mands_r_noh="$mands --search '$random_noh' -"

        export mands_rd_fifo_noh="  $mands --search '$rd_fifo_noh' -"
        export mands_rd_lifo_noh="  $mands --search '$rd_lifo_noh' -"
        export mands_rd_random_noh="$mands --search '$rd_random_noh' -"
        export mands_fd_fifo_noh="  $mands --search '$fd_fifo_noh' -"
        export mands_fd_lifo_noh="  $mands --search '$fd_lifo_noh' -"
        export mands_fd_random_noh="$mands --search '$fd_random_noh' -"
        export mands_ld_fifo_noh="  $mands --search '$ld_fifo_noh' -"
        export mands_ld_lifo_noh="  $mands --search '$ld_lifo_noh' -"
        export mands_ld_random_noh="$mands --search '$ld_random_noh' -"

        export mands_rx="  $mands   --search '$randomx' -"
        export mands_rd_randomx="$mands --search '$rd_randomx' -"
        export mands_fd_randomx="$mands --search '$fd_randomx' -"
        export mands_ld_randomx="$mands --search '$ld_randomx' -"
        export mands_rx_noh="  $mands   --search '$randomx_noh' -"

 
        export mands_typed=" $mands --search '$typed' -"

        # testing purpose
        export mands_ffff=" $mands --search 'multi([$fifo,$fifo])' -"
        export mands_multi_ff=" $mands --search 'multi([$fifo])' -"
        export mands_multi_zero=" $mands --search 'multi([])' -"

        # multisearch
        export mands_m2="$mands --search 'multi([$ld_fifo,$rd_random])' -"
        export mands_m3="$mands --search 'multi([$ld_fifo,$rd_random,$ld_lifo])' -"
        export mands_m4="$mands --search 'multi([$ld_fifo,$rd_random,$rd_lifo,$ld_lifo])' -"
        export mands_m5="$mands --search 'multi([$ld_fifo,$rd_random,$fd_lifo,$rd_lifo,$ld_lifo])' -"
    }
    # blind
    {
        export blind_ff=" $blind --search '$fifo' -"
        export blind_lf=" $blind --search '$lifo' -"
        export blind_r="  $blind   --search '$random' -"

        export blind_rd_fifo="  $blind --search '$rd_fifo' -"
        export blind_rd_lifo="  $blind --search '$rd_lifo' -"
        export blind_rd_random="$blind --search '$rd_random' -"
        export blind_fd_fifo="  $blind --search '$fd_fifo' -"
        export blind_fd_lifo="  $blind --search '$fd_lifo' -"
        export blind_fd_random="$blind --search '$fd_random' -"
        export blind_ld_fifo="  $blind --search '$ld_fifo' -"
        export blind_ld_lifo="  $blind --search '$ld_lifo' -"
        export blind_ld_random="$blind --search '$ld_random' -"
 
        export blind_lf_noh=" $blind --search '$lifo_noh' -"
        export blind_ff_noh=" $blind --search '$fifo_noh' -"
        export blind_r_noh="$blind --search '$random_noh' -"

        export blind_rd_fifo_noh="  $blind --search '$rd_fifo_noh' -"
        export blind_rd_lifo_noh="  $blind --search '$rd_lifo_noh' -"
        export blind_rd_random_noh="$blind --search '$rd_random_noh' -"
        export blind_fd_fifo_noh="  $blind --search '$fd_fifo_noh' -"
        export blind_fd_lifo_noh="  $blind --search '$fd_lifo_noh' -"
        export blind_fd_random_noh="$blind --search '$fd_random_noh' -"
        export blind_ld_fifo_noh="  $blind --search '$ld_fifo_noh' -"
        export blind_ld_lifo_noh="  $blind --search '$ld_lifo_noh' -"
        export blind_ld_random_noh="$blind --search '$ld_random_noh' -"

        export blind_typed=" $blind --search '$typed' -"

        # testing purpose
        export blind_ffff=" $blind --search 'multi([$fifo,$fifo])' -"
        export blind_multi_ff=" $blind --search 'multi([$fifo])' -"
        export blind_multi_zero=" $blind --search 'multi([])' -"

        # multisearch
        export blind_fflf=" $blind --search 'multi([$lifo,$fifo])' -"
        export blind_ffr="  $blind --search 'multi([$fifo,$random])' -"
        export blind_lfr="  $blind --search 'multi([$lifo,$random])' -"
        export blind_fflfr="$blind --search 'multi([$lifo,$fifo,$random])' -"

        export blind_rdlf="  $blind --search 'multi([$lifo,$rd])' -"
    }
}
# CAP configs
{
export ff="     $nocost --both-search ff-clean -"
export probe="          --both-search probe-clean -"
export mv="     $nocost --both-search marvin2-clean -"
export mv1="    $nocost --both-search marvin1-clean -"
export lpg="    $nocost --both-search lpg-clean -"

export m="              --both-search m-clean -"
export mp="             --both-search mp-clean -"
export mpc="            --both-search mpc-clean -"

export yhyh="   --both-search yahsp3-clean -"
export mcmc="   --both-search mercury-clean -"
export jaja="   --both-search jasper-clean -"
export yhja="   --main-search jasper-clean - --preprocessor yahsp3-clean -"
export yhmc="   --main-search mercury-clean - --preprocessor yahsp3-clean -"

export yhib_mco=" --ipc-threads --main-search ibacop-mco-clean - --preprocessor yahsp3-clean -"
export yhar_mco=" --ipc-threads --main-search arvandherd-mco-clean - --preprocessor yahsp3-clean -"
export yhyh_mco=" --ipc-threads --main-search yahsp-mco-clean - --preprocessor yahsp3-clean -"
export yh_mcoyh_mco=" --both-search yahsp-mco-clean -"

export ar_mcoar_mco=" --both-search arvandherd-mco-clean -"
export ar_aglar_mco=" --main-search arvandherd-mco-clean - --preprocessor arvandherd-agl-clean -"

export fffd="--main-search fd-clean '$lama2011' - --preprocessor ff-clean - --remove-component-problem-cost"
export prfd="--main-search fd-clean '$lama2011' - --preprocessor probe-clean -"
export yhfd="--main-search fd-clean '$lama2011' - --preprocessor yahsp3-clean -"
# export solep="  $nocost --both-search solep-clean - $trainings"
# export trainings="--training t01.pddl --training t02.pddl --training t03.pddl"
}

export nil=""

gen=gen


# this requires /asai cgroup
export test1=" -q agile -g /$(whoami) -m 2000000 -M 2000000 -t 60 -T 60"
export test2=" -q agile -g /$(whoami) -m 2000000 -M 2000000 -t 120 -T 120"
export test5=" -g /$(whoami) -m 2000000 -M 2000000 -t 300 -T 300"
export test5_4g=" -q batch -g /$(whoami) -m 4000000 -M 4000000 -t 300 -T 300"
export test10="-P 1 -q batch -g /$(whoami) -m 2000000 -M 2000000 -t 600 -T 600"
export test20="-P 1 -g /$(whoami) -m 2000000 -M 2000000 -t 1200 -T 1200"
export ipc="   -g /$(whoami) -m 2000000 -M 2000000 -t 1800 -T 1800"
export ipc4g="   -g /$(whoami) -m 4000000 -M 4000000 -t 1800 -T 1800"
export long="   -g /$(whoami) -m 2000000 -M 2000000 -t 3600 -T 3600"
export long16g=" -g /$(whoami) -m 16000000 -M 16000000 -t 3600 -T 3600"
export doubling16g=" -g /$(whoami) -m 500000 -M 16000000 -t 3600 -T 3600"
export learn=" -g /$(whoami) -m 4000000 -M 4000000 -t 900 -T 900"

export mco=" -g /$(whoami) -u 1000000 -m 4000000 -M 4000000 -t 1800 -T 1800"

resources="test1 | test2 | test5 | test5_4g | test10 | test20 | ipc | long | learn"
