#!/bin/bash

. $WORLD_HOME/run/next.sh

echo "-*- truncate-lines : t -*- "
echo "-*- truncate-lines : t -*- " >&2
echo "$(whoami)@$(hostname)"
echo $cg_cpuacct_parent
echo $cg_cpuacct
echo $cg_cpuacct_dir
echo $cg_options
echo "iterator.sh($$): removing and making cgdir"

reset-dir (){
    while [[ -e $1 ]]
    do
        rmdir -v $1/*
        rmdir -v $1
    done
    mkdir -vp $1
}
reset-dir $cg_cpuacct_dir
reset-dir $cg_memory_dir
reset-dir $cg_cpu_dir

echo 0 > $cg_memory_dir/memory.swappiness
echo 1 > $cg_memory_dir/memory.use_hierarchy
echo $(($mem * 1024)) > $cg_memory_dir/memory.limit_in_bytes
echo $(($mem * 1024)) > $cg_memory_dir/memory.memsw.limit_in_bytes
echo 100000 > $cg_cpu_dir/cpu.cfs_period_us
echo $((100000 * $ppn)) > $cg_cpu_dir/cpu.cfs_quota_us

sleep=60
walltime=
mykill (){
    ps $1 &> /dev/null && {
        pstree -p -H $1 $1
        echodo kill -n USR1 $(pgrep -P $1)
        echodo sleep $sleep
        echo "iterator.sh($$): sleep end"
        ps $1 &> /dev/null && {
            echodo $WORLD_HOME/util/killall.sh $1 -9
        }
    }
}
twice-time (){
    echo "iterator.sh($$): Current iteration failed! Doubling the time..."
    echo "iterator.sh($$): status: time:$time maxtime:$maxtime"
    (
        time=$(( 2 * $time ))
        if [[ $time -gt $maxtime ]]
        then
            echo "iterator.sh($$): Failed, no more iteration!"
            return 1
        else
            next                    # throw the next job
        fi
    )
}
twice-memory (){
    echo "iterator.sh($$): Current iteration failed! Doubling the memory..."
    echo "iterator.sh($$): status: mem:$mem maxmem:$maxmem"
    ( 
        mem=$(( 2 * $mem ))
        echo "iterator.sh($$): next iteration: $mem < $maxmem ?"
        if [[ $mem -gt $maxmem ]]
        then
            echo "iterator.sh($$): Failed, no more iteration!"
            return 1
        else
            echo "iterator.sh($$): Success, submitting next iteration!"
            next                    # throw the next job
        fi
    )
}
check-cputime (){
    if [[ $cpuusage -ge ${time}000 ]]
    then
        echo "iterator.sh($$): cpuacct.usage exceeding. $cpuusage msec."
        mykill $pid
        return 1
    fi
}
check-walltime (){
    if [[ $walltime -ge $time ]]
    then
        echo "iterator.sh($$): walltime exceeding. $walltime sec."
        mykill $pid
        return 1
    fi
}
check-memory (){ 
    if [[ $memusage -ge $mem ]]
    then
        echo "iterator.sh($$): memory.max_usage_in_bytes exceeding. $memusage kB."
        mykill $pid
        return 1
    fi
}
finalize (){
    echo "iterator.sh($$): real $cpuusage (msec.)"
    echo "iterator.sh($$): maxmem $memusage (kB)"
    rmdir -v $cg_cpuacct_dir/* $cg_memory_dir/*
    rmdir -v $cg_cpuacct_dir $cg_memory_dir
}
trap finalize EXIT

update (){
    walltime=$(($(date +%s)-$start))
    cpuusage=$(($(< $cg_cpuacct_dir/cpuacct.usage) / 1000000))
    memusage=$(( $(< $cg_memory_dir/memory.max_usage_in_bytes) / 1024 ))
}

cgexec $cg_options $command &
pid=$!
start=$(date +%s)
update

while ps $pid &> /dev/null
do
    sleep 1
    update
    check-walltime || break
    check-memory   || break
done

wait $pid
exitstatus=$?

case $exitstatus in
    0) echo "iterator.sh($$): The program successfully finished." ;;
    *) 
        echo "iterator.sh($$): Error occured. status: $exitstatus"
        if ! check-walltime
        then
            twice-time && exit 1
        fi
        if ! check-memory
        then
            twice-memory && exit 1
        fi
        if check-memory && check-walltime
        then
            echo "iterator.sh($$): Finished within time/memory limit"
        else
            echo "iterator.sh($$): Exceeded the limit, but no extension available"
        fi
        ;;
esac

