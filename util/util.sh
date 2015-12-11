#!/bin/bash

export SRCDIR=$(dirname $(readlink -ef $0))

ref (){
    if eval "[ -z \${$1+x} ]"
    then
        echo "undefined variable $1 !" >&2
        local i=0; while caller $i >&2 ;do ((i++)) ;done
        exit 1
    else
        eval "echo -n \$$1"
    fi
}

echodo (){
    echo $*
    $@
}

export -f ref
export -f echodo

bgrun (){
    local max=$1
    shift
    while [[ $(jobs | wc -l) -ge $max ]]
    do
        sleep 1
    done
    eval "$*" &
}

export -f bgrun
