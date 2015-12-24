#!/bin/bash

. $WORLD_HOME/template/common.sh


sets="allpath10"

expected_conf="ipc"

echo "#!/bin/bash"

filter-quoted (){
    echo "
    {
        tmp=\$(mktemp)
        while read line ; do
            [[ \$line ~= *.macro.$1.* ]] && echo \$line
        done | sort -R > \$tmp
        lines=\$(wc -l < \$tmp)
        head -n \$((\$lines*$2/100)) < \$tmp
        rm \$tmp
    }
"
}

filter (){
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

# filter 5 10

p=lama
for s in $sets ; do
    for length in {2..10} ; do
        for percent in 10 20 50 90
        do
            gen -s $s -n ${p}-$length-$percent $base $macrocost
            filter $length $percent
            echo "run $expected_conf results/$s-*-${p}-$length-$percent-*"
        done
    done
done


