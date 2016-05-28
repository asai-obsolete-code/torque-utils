#!/bin/bash

. $WORLD_HOME/util/util.sh

export_vars="nodes ppn mem maxmem time maxtime debug queue jobname_suffix dir command outname WORLD_HOME"

next(){
    jobname_suffix=.$time.$mem
    
    for var in $export_vars
    do
        export $var
    done
    variables=$(
        for var in $export_vars
        do
            eval "echo -n ,$var=\"\$$var\""
        done
    )
    if echodo qsub \
        -l "mem=$mem" \
        -l "walltime=$time" \
        -l "nodes=$nodes:ppn=$ppn" \
        $([ -z $queue ] || echo "-q $queue") \
        -N $(basename $dir | sed 's/[aeiou]//g' | head -c3)$(echo $outname | tail -c +2) \
        -o $dir/$outname$jobname_suffix.out \
        -e $dir/$outname$jobname_suffix.err \
        -v ${variables:1} $WORLD_HOME/run/iterator.sh
    then
        echo "next.sh($$): submitted: with mem=$mem, walltime=$time"
        return 0
    else
        echo "next.sh($$): failed: mem=$mem, walltime=$time"
        return 1
    fi
    # -V      Declares that all environment variables in the qsub command's environment are to  be
    #         exported to the batch job.
}

