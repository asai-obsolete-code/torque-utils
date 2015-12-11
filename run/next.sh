#!/bin/bash

. $WORLD_HOME/util/util.sh

cgfs_root=/sys/fs/cgroup
cg_cpuacct_parent=${cg_cpuacct_parent:-$(awk -F: '/:cpuacct:/{print $3}' /proc/self/cgroup)} # it may be a /
cg_memory_parent=${cg_memory_parent:-$(awk -F: '/:memory:/{print $3}' /proc/self/cgroup)} # it may be a /
cg_cpu_parent=${cg_cpu_parent:-$(awk -F: '/:cpu:/{print $3}' /proc/self/cgroup)} # it may be a /

if [[ $cg_cpuacct_parent == / ]]
then
    cg_cpuacct=/$$
else
    cg_cpuacct=$cg_cpuacct_parent/$$
fi

if [[ $cg_memory_parent == / ]]
then
    cg_memory=/$$
else
    cg_memory=$cg_memory_parent/$$
fi

if [[ $cg_cpu_parent == / ]]
then
    cg_cpu=/$$
else
    cg_cpu=$cg_cpu_parent/$$
fi


cg_options="-g cpuacct:$cg_cpuacct -g memory:$cg_memory -g cpu:$cg_cpu"
cg_cpuacct_dir=$cgfs_root/cpuacct$cg_cpuacct
cg_memory_dir=$cgfs_root/memory$cg_memory
cg_cpu_dir=$cgfs_root/cpu$cg_cpu

export_vars="unit_mem nodes ppn mem maxmem time maxtime debug priority queue jobname_suffix dir command cg_cpuacct_parent cg_memory_parent cg_cpu_parent outname WORLD_HOME"

next(){
    ppn=$(( $mem / $unit_mem ))
    [[ $ppn == 0 ]] && ppn=1
    jobname_suffix=.$time.$mem
    
    for arg in $export_vars
    do
        export $arg
    done

    if echodo qsub \
        -l "mem=$((200000 + $mem )),pmem=$((200000 + $mem ))" \
        -l "walltime=$(( 120 + $time ))" \
        -l "nodes=$nodes:ppn=$ppn" \
        $([ -z $priority ] || echo "-p $priority") \
        $([ -z $queue ] || echo "-q $queue") \
        -N $(basename $dir | head -c4)$(echo $outname | tail -c +2) \
        -o $dir/$outname$jobname_suffix.out \
        -e $dir/$outname$jobname_suffix.err \
        -V $WORLD_HOME/run/iterator.sh
    then
        echo "next.sh($$): submitted: with mem=$((200000 + $mem )), walltime=$(( 120 + $time ))"
        return 0
    else
        echo "next.sh($$): failed: mem=$((200000 + $mem )), walltime=$(( 120 + $time ))"
        return 1
    fi
    # -V      Declares that all environment variables in the qsub command's environment are to  be
    #         exported to the batch job.
}

