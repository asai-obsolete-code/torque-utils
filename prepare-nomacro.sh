#!/bin/bash

. $WORLD_HOME/template/common.sh


sets="macros10 macros2 macros3 macros4 macros5 macros6 macros7 macros8 macros9"

expected_conf="ipc"

echo "#!/bin/bash"

filter-old (){
    local h=$(find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | wc -l)
    echo "# ----------------------"
    echo "# $h macros present"
    find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | while read line
    do
        if ! [[ $line =~ ".macro.$1." ]]
        then
            rm $line
        fi
    done
    local j=$(find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | wc -l)
    local i=$((h-j))
    echo "# $i macros removed (not of length $1)"
    echo "# $j macros remaining"
    local k=$((($j*(1+$2)/100) + 1))
    find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | sort -R | tail -n +$k | xargs rm
    echo "# $((j-k)) macros removed"
    local l=$(find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | wc -l)
    echo "# $l macros remaining (roughly $2%)"
}

filter (){
    echo "# ----------------------"
    local j=$(find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | wc -l)
    echo "# (length,percent)=($1,$2): $j macros remaining"
    local k=$((($j*(1+$2)/100) + 1))
    find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | sort -R | tail -n +$k | xargs rm
    echo "# (length,percent)=($1,$2): $((j-k)) macros removed"
    local l=$(find results/$s-*-${p}-$1-$2-* -name "*.macro.*" | wc -l)
    echo "# (length,percent)=($1,$2): $l macros remaining (roughly $2%)"
}

# filter 5 10

p=lama
for s in $sets ; do
    length=${s##macros}
    for percent in 0
    do
        (
            gen -s $s -n ${p}-$length-$percent $base $macrocost
            filter $length $percent >&2
        ) &
        echo "run $expected_conf results/$s-*-${p}-$length-$percent-*"
    done
done


wait
