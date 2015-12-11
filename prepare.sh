#!/bin/bash

. $WORLD_HOME/template/common.sh

sets="set8 set9"

expected_conf="ipc"
tl="tl15"

echo "#!/bin/bash"

# heuristics="yh mc ja"
# for h in $heuristics; do for s in $sets ; do
#         p="${h}${h}"
#         ref $p >/dev/null
#         gen -s $s -n $h $base $(ref $p) $plain
#         echo "run $expected_conf results/$s*-${h}-*"
#     done
# done

heuristics="mcmc jaja"
# heuristics="yhyh mcmc jaja yhja yhmc"
for p in $heuristics; do for s in $sets ; do
        ref $p >/dev/null
        gen -s $s -n ${p}  $base $(ref $p) $(ref $tl) $macrocost $ca
        echo "run $expected_conf results/$s*-${p}-*"
    done
done


