#!/bin/bash

vars="L K seed domain coverage primitive added used time gen eval exp bps landmark"

if [ -z $1 ]
then
    echo $vars | sed 's/ /, /g'
    exit
fi

export FIND="find -L"

common(){
    $FIND $1 -name '*.out' | xargs cat
}


dir=$1
# echo $dir >&2
# set1-lisp-compatible-lama-0-0-0-665919-2016-01-08-10-47/barman/
L=$(basename $(dirname $dir) | cut -d- -f5)
K=$(basename $(dirname $dir) | cut -d- -f6)
seed=$(basename $(dirname $dir) | cut -d- -f7)
domain=$(basename $dir)
coverage=$($FIND $dir -name "*.plan.1" | wc -l)
added=$(common $dir | awk '/with [0-9]* macros/{sum+=int($(NF-1))}END{print sum}')
action_lisp=$(common $dir | awk '/Number of instantiated ground actions/{sum+=$7}END{print sum/2}')
# action_rem_transl=$(common $dir | awk '/operators removed/{sum+=$1}END{print sum}')
# action_transl=$(common $dir | awk '/Translator operators/{sum+=$3}END{print sum}')
# action_preprocess1=$(common $dir | awk '/operators necessary./{sum+=$3}END{print sum}')
# action_preprocess2=$(common $dir | awk '/operators necessary./{sum+=$1}END{print sum}')
primitive=$action_lisp
used=$(common $dir | grep -c "Decoding action")
# usedj=$(common $dir | grep -c "Decoding action JUNK")
time=$(common $dir | awk '/Actual search time/{sum+=substr($4,0,length($4)-1)} END{print sum}')
gen=$(common $dir | awk '/Generated [0-9]* state/{sum+=$2}  END{print sum}')
eval=$(common $dir | awk '/Evaluated [0-9]* state/{sum+=$2} END{print sum}')
exp=$(common $dir | awk '/Expanded [0-9]* state/{sum+=$2}   END{print sum}')
bps=$(common $dir | awk '/Bytes per state/{sum+=$4} END{print sum}')
landmark=$(common $dir | awk '/Discovered [0-9]* landmarks/{sum+=$2} END{print sum}')

first=true
for var in $vars ; do
    ! $first && echo -n ", "
    first=false
    eval echo -n \$$var
done
echo

