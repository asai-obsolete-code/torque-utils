#!/bin/bash

. $WORLD_HOME/template/common.sh


sets="macros2 macros3 macros4 macros5 macros6 macros7 macros8 macros9 macros10"

expected_conf="ipc"

echo "#!/bin/bash"

p=lama
for s in $sets ; do
    length=${s##macros}
    for percent in 0 10 20 50 90
    do
        gen -m $percent -s $s -n ${p}-$length-$percent $base $macrocost &
        echo "run $expected_conf results/$s-*-${p}-$length-$percent-*"
        for split in 1 2 3
        do
            (
                gen -m $percent -s $s -n ${p}-$length-$percent-$split $base $macrocost
                expdir=$(ls -d results/$s-*-${p}-$length-$percent-$split-*)
                find sets/split$split -name "*.macro.*" | while read src ; do
                    dest=$expdir${src##sets/split$split}
                    ln -s ../../../$src $dest
                done
            ) &
            echo "run $expected_conf results/$s-*-${p}-$length-$percent-$split-*"
        done
    done
done

finalize (){
    pkill -P $$
}

trap finalize EXIT

wait
