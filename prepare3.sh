#!/bin/bash

. $WORLD_HOME/template/common.sh


# sets="macros2 macros3 macros4 macros5 macros6 macros7 macros8 macros9 macros10"

expected_conf="ipcmicro"

echo "#!/bin/bash"

s=set1
p=lama
for length in {2..10} ; do
    for percent in 0.1 # 0.2 0.5 1 2 5
    do
        name=${p}-$length-$percent-ns
        gen -s $s -n $name $base $macrocost --junk $length $percent &
        echo "run $expected_conf results/$s-*-$name-*"
        for split in 1 2 3
        do
            name=${p}-$length-$percent-$split
            # (
                gen -s $s -n $name $base $macrocost --junk $length $percent 
                expdir=$(ls -d results/$s-*-$name-*)
                find sets/split3-$split/ -name "*.macro.*" | while read src ; do
                    dest=$expdir${src##sets/split3-$split}
                    ln -s ../../../$src $dest
                done
            # ) &
            echo "run $expected_conf results/$s-*-$name-*"
        done
    done
done

finalize (){
    pkill -P $$
}

trap finalize EXIT

wait
