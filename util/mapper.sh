#!/bin/bash

mapset (){
    for dirname in $(ls -d sets/*/)
    do
        export setname=$(basename $dirname)
        pushd $dirname &> /dev/null
        $@
        popd &> /dev/null
    done
}


mapdom (){
    for dirname in $(ls -d */)
    do
        export domname=$(basename $dirname)
        pushd $dirname &> /dev/null
        $@
        popd &> /dev/null
    done
}

mapprob (){
    for problem in $(find -regex ".*/p[0-9]+\.pddl")
    do
        export problem=$(readlink -ef $problem)
        export probname=$(basename $problem .pddl)
        export pnum=${probname##p}
        $@
    done
}
