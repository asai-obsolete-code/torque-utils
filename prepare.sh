#!/bin/bash

. $WORLD_HOME/template/common.sh


sets="allpath10"

expected_conf="ipc"

echo "#!/bin/bash"

filter (){
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

# filter 5 10

p=lama
for s in $sets ; do
    for length in {2..10} ; do
        for percent in $(seq 10 10 100)
        do
            gen -s $s -n ${p}-$length-$percent -f "$(filter $length $num)" $base $macrocos
            echo "run $expected_conf results/$s-*-${p}-$length-$percent-*"
        done
    done
done


