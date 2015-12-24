#!/bin/bash

. $WORLD_HOME/template/common.sh


sets="set1"

expected_conf="long"

echo "#!/bin/bash"

p=lama
for s in $sets ; do
    for i in {2..10}
    do
        gen -s $s -n ${p}-blind$i $base $macrocost $(blind $i) $nocost
        echo "run $expected_conf results/$s-*-${p}-blind$i-*"
    done
done
