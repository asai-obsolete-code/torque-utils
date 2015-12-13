#!/bin/bash

. $WORLD_HOME/template/common.sh

# sets="split1 split2 split3 split4 split5 split6 split7 split8 split9 split10"
# sets="set1"
# sets="split1 split2 split10"
sets="split3 split4 split5 split6 split7 split8 split9"

expected_conf="test10"

echo "#!/bin/bash"

p=lama
for s in $sets ; do
    gen -s $s -n ${p} $base $macrocost
    echo "run $expected_conf results/$s-*-${p}-*"
done
