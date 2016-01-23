#!/bin/bash

find -name "*4000000*" | while read line; do
    # p01.mp-3-25-1800-ns.14400.4000000.out
    smaller=$(echo $line | sed 's/4000000/2000000/g')
    # echo $line, $smaller | sed 's_\./set1-lisp-compatible-mp-__'
    [ -e $smaller ] && echo $smaller
done
