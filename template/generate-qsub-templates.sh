#!/bin/bash

# Generate lots of qsub scripts statically

. $WORLD_HOME/util/util.sh

run=true
random=false
name=noname
filter=cat
macropercent=0
while getopts ":R:n:s:f:m:" opt
do
    case ${opt} in
        R)  # random
            howmany=${OPTARG}
            random=true ;;
        n)  name=${OPTARG} ;;
        m)  macropercent=${OPTARG};;
        s)  probset=${OPTARG} ;;
        f)  filter=${OPTARG} ;;
        \?) OPT_ERROR=1; break ;;
        * ) echo "unsupported option $opt" ;;
    esac
done

shift $(($OPTIND - 1))
bin=$(readlink -ef $1)
shift
args="$bin $@"

if [[ ( $1 == "" ) || $OPT_ERROR ]]
then
    cat >&2 <<EOF
usage: ./generate-qsub-templates.sh
           [-r resource]
           [-R howmany]
           [-s problemset]
           [-n name]
           args
EOF
    exit 1
fi

expdir-name (){
    pushd $1 >/dev/null
    echo -n "$(basename $(pwd))-"
    echo -n "$(basename $(git symbolic-ref HEAD))-"
    echo -n "$name-"
    echo -n "$(git --no-pager log -1 --pretty=oneline | head -c6)-"
    date +"%Y-%m-%d-%H-%M"
    popd >/dev/null
}

probdir=sets/$probset
mkdir -p results
expdir=results/$(expdir-name $probdir)

find $probdir -name "*.pddl" | while read src ; do
    dest=$expdir${src##$probdir}
    mkdir -p $(dirname $dest)
    ln -s ../../../$src $dest
done

# below method is far from ideal, the result does not corresponds to the given percent
# RAND_MAX=32767
# find $probdir -name "*.macro.*" | while read src ; do
#     if [ $(echo "scale=2 ; ($RANDOM/$RAND_MAX)*100" | bc | sed "s/\.*//g") -lt $macropercent ]
#     then
#         dest=$expdir${src##$probdir}
#         mkdir -p $(dirname $dest)
#         ln -s ../../../$src $dest
#     fi
# done

if [ $macropercent != 0 ]
then
    for prob in $(ls $probdir/*/*.pddl | grep -v domain)
    do
        wild="${prob%%.pddl}.macro.*"
        total=$(ls $wild | wc -l)
        # chosen=$(echo "scale=2 ; 0.01+($total*$macropercent)/100" | bc | sed "s/\..*//g")
        chosen=$(echo "$total $macropercent" | awk '{print int($1 * $2 / 100) }')
        [ $chosen == 0 ] && chosen=1
        # echo "total: $total chosen: $chosen" >&2
        for src in $(ls $wild | sort -R | head -n $chosen)
        do
            dest=$expdir${src##$probdir}
            mkdir -p $(dirname $dest)
            ln -s ../../../$src $dest
        done
    done
fi

# git archive \
#     --format=tar \
#     --remote=$probdir \
#     --prefix=$expdir/ HEAD | tar xf - || exit 1

if $random
then
    problems=$(find $expdir -regex ".*/p[0-9]*.pddl" | sort -R | head -n $howmany)
else
    problems=$(find $expdir -regex ".*/p[0-9]*.pddl" )
fi

main (){
    for problem in $problems
    do
        problem=$PWD/$problem
        dir=$(dirname $problem)
        probname=$(basename $problem .pddl)
        outname="$probname.$name"
        qsub=${problem%.pddl}.$name.qsub
        render $args > $qsub
        chmod +x $qsub
    done
}

render (){
    if [[ -e $dir/domain.pddl ]]
    then
        domain=$dir/domain.pddl
    else
        domain=$dir/$probname-domain.pddl
    fi
    domname=$(basename $domain .pddl)
    template=$(dirname $(readlink -ef $0))/template.qsub
    cat <<EOF
#!/bin/bash
outname=$outname
dir=$dir
problem=$problem
probname=$probname
domain=$domain
domname=$domname
args="$*"
filter="$filter"
. $template
EOF
}

main
