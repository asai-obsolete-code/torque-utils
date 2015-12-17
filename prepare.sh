#!/bin/bash

. $WORLD_HOME/template/common.sh


sets="set1"

expected_conf="long"

echo "#!/bin/bash"

p=lama
for s in $sets ; do
    gen -s $s -n ${p} $base $macrocost $(blind 11) $nocost
    echo "run $expected_conf results/$s-*-${p}-*"
done
