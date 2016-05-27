#!/bin/bash

. $WORLD_HOME/run/next.sh

echo "-*- truncate-lines : t -*- "
echo "-*- truncate-lines : t -*- " >&2

# 5:memory:/user/1000.user/2.session

cg_memory_dir=/sys/fs/cgroup/memory/$(cat /proc/self/cgroup | grep memory | cut -d: -f3)
cg_cpuacct_dir=/sys/fs/cgroup/cpuacct/$(cat /proc/self/cgroup | grep cpuacct | cut -d: -f3)

for f in $(ls $cg_memory_dir);do
    [ -f $f ] && cat $f
done

sleep=10
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
}
trap finalize EXIT

update (){
    walltime=$(($(date +%s)-$start))
    cpuusage=$(($(< $cg_cpuacct_dir/cpuacct.usage) / 1000000))
    memusage=$(( $(< $cg_memory_dir/memory.max_usage_in_bytes) / 1024 ))
}

$command

#  &
# pid=$!
# start=$(date +%s)
# update

# while ps $pid &> /dev/null
# do
#     sleep 1
#     update
#     check-walltime || break
#     check-memory   || break
# done

# wait $pid
# exitstatus=$?

# case $exitstatus in
#     0) echo "iterator.sh($$): The program successfully finished." ;;
#     *) 
#         echo "iterator.sh($$): Error occured. status: $exitstatus"
#         if ! check-walltime
#         then
#             twice-time && exit 1
#         fi
#         if ! check-memory
#         then
#             twice-memory && exit 1
#         fi
#         if check-memory && check-walltime
#         then
#             echo "iterator.sh($$): Finished within time/memory limit"
#         else
#             echo "iterator.sh($$): Exceeded the limit, but no extension available"
#         fi
#         ;;
# esac

