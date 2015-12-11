#!/bin/bash

. $(dirname $(readlink -ef $0))/util/doubling.sh

for dir in */
do
    d=$(basename $dir)

    i=0
    for f in $(ls -1 $d/p*.pddl | head -n 3)
    do
        i=$((i+1))
        # echo $f
        echodo rm -f $d/t0$i.pddl
        echodo cp $f $d/t0$i.pddl
    done
done
