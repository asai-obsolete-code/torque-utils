#!/bin/bash

debuglevel=1
case $1 in
    -d) debuglevel=$(($2))
        shift 2
        ;;
    -*) echo "$0 [-d debuglevel] path"
        exit 1
        ;;
    *) ;;
esac

val=$WORLD_HOME/util/validate
set=$1
i=1
max=60
failed=$(mktemp)
invalid=$(mktemp)
notrun=$(mktemp)

newline (){
    if [[ $i -gt $max ]]
    then
        echo
        i=1
    fi
}

val-plus (){

    problem=$1
    probname=$(basename $problem)
    probname=$(dirname $problem)/${probname%%.*}
    log=$(ls $probname.*.out | head -n 1)
    if [[ ! -e $log ]]
    then
        echo -n e
        i=$(( $i + 1 ))
        newline
        printf "%20s%40s\n" "$domname" "$probname.$config.qsub" >> $notrun
        return 1
    fi
    if [[ -e $(dirname $problem)/domain.pddl ]]
    then
        domain=$(dirname $problem)/domain.pddl
    else
        domain=$probname-domain.pddl
    fi
    newline
    if ls $probname.*.plan* &>/dev/null
    then
        for plan in $(ls $probname.*.plan* 2>/dev/null)
        do
            if $val $domain $problem $plan &> /dev/null
            then
                echo -n .
            else
                echo -n X
                printf "%20s%40s%60s\n" "$set" "$domname" "$plan" >> $invalid
            fi
            i=$(( $i + 1 ))
            newline
        done
    else
        echo -n F
        i=$(( $i + 1 ))
        newline
        printf "%20s%40s%60s\n" "$set" "$domname" "$probname.*.plan*" >> $failed
        return 1
    fi
}

finalize (){
    echo
    echo "In $set:"
    echo "Invalid Plans:"
    cat $invalid ; rm $invalid
    [[ $debuglevel -lt 2 ]] && return 0
    echo "Plan Not Found:"
    cat $failed ; rm $failed
    echo
    [[ $debuglevel -lt 3 ]] && return 0
    echo "Problems not run:"
    cat $notrun ; rm $notrun
    echo
    [[ $debuglevel -lt 4 ]] && return 0
    echo "Debugger Entered:"
    find -name "*.err" | xargs -n 1 grep -H "debugger" | cut -f1 -d:
}
trap "finalize" EXIT

find $set -name "*.pddl" | grep -v domain | while read line ; do 
    val-plus $line
done
