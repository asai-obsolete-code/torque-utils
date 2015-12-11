#!/bin/bash

map (){
    if [[ $2 != "" ]]
    then
        local pred=$1
        local first=$2
        shift 2
        echo $($pred $first)
        map $pred $@
    fi
}

reduce (){                         # list of numbers
    if [[ $3 == "" ]]
    then
        echo $2
    else
        local pred=$1
        local first=$2
        local second=$3
        shift 3
        local next=$($pred $first $second)
        reduce $pred $next $@
    fi
}

gensym (){ mktemp --tmpdir lambda.XXXXXXXX; }
localdef (){ echo "$1=$2;" ;}
localdefs (){
    local i=0
    for arg in $@
    do
        i=$(( $i + 1 ))
        localdef $arg "\$$i"
    done
}
lambda (){
    local sym=$(gensym)
    local args=
    while [[ $1 != "--" ]]
    do
        args="$args $1"
        shift
    done
    shift
    echo "#!/bin/bash" > $sym
    localdefs $args >> $sym
    echo "{ $* ;}" >> $sym
    # echo "defining lambda in $sym:" >&2
    # cat $sym >&2
    chmod +x $sym
    echo $sym
}

gc (){
    rm -r /tmp/lambda.*
}

gt (){ if [[ $1 -gt $2 ]] ; then echo $1 ; else echo $2 ; fi }
lt (){ if [[ $1 -lt $2 ]] ; then echo $1 ; else echo $2 ; fi }
ge (){ if [[ $1 -ge $2 ]] ; then echo $1 ; else echo $2 ; fi }
le (){ if [[ $1 -le $2 ]] ; then echo $1 ; else echo $2 ; fi }
max (){ reduce gt $@ ;}
min (){ reduce lt $@ ;}

countline (){
    wc -l < $1
}

wrap (){                        # lisp hack !!!
    echo -n "("
    ## echo $* >&2 # for debugging
    eval $*
    echo -n ")"
}

export -f map
export -f reduce
export -f gensym
export -f localdef
export -f localdefs
export -f lambda
export -f gc
export -f gt
export -f lt
export -f ge
export -f le
export -f max
export -f min
export -f countline
export -f wrap
