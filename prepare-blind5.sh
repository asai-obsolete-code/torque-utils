#!/bin/bash

. $WORLD_HOME/template/common.sh


sets="set1"

expected_conf="long"

echo "#!/bin/bash"

p=lama
for s in $sets ; do
    gen -s $s -n ${p} $base $macrocost $(blind 6) $nocost
    echo "run $expected_conf results/$s-*-${p}-blind6-*"
done
