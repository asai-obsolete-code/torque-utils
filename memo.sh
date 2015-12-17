

# remove all problems which:
# 
# + failed to expand all nodes within f=10 under 2GB
# + failed to dump all nodes within f=10 under 1hrs

# before removing: 598 problems

# step1: remove when f=10 did not fit in 2GB
find -name "*.pddl" | grep -v domain | while read f
do
 (ls ${f%%.pddl}.*.plan.* &> /dev/null) || (rm ${f%%.pddl}*)
done

# after step1: 239 problems

# find -name "*-domain.pddl" | while read f
# do
#   [ -e $(basename $f -domain.pddl).pddl ] || rm $f
# done

# step2: remove unnecessary files
find -name "*.qsub" -delete
find -name "*.err" -delete

# step3: remove when the data transfer did not finish
find -name "*.out" | while read f
do
    # ls ${f%%out}plan* | wc -l
    # awk -e '/Number of registered states/{print $5}' < $f
    if ( ! grep -q 'Number of registered states' $f ) || \
        [ $(ls ${f%%out}plan* 2>/dev/null | wc -l) -ne \
        $(awk -e '/Number of registered states/{print $5}' < $f) ]
    then
        name=$(basename $f)
        name=${name%%.*}
        echo "ng: $(dirname $f)/$name*"
        rm $(dirname $f)/$name*
    fi
done


# remaining problems: 212
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/psr-small/p15*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/visitall-opt11-strips/p08*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/blocks/p25*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/transport-opt11-strips/p04*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/hanoi/p11*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/hanoi/p10*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/hanoi/p09*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/hanoi/p12*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/hanoi/p08*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/hanoi/p13*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/mystery/p11*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/tpp/p05*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/logistics00/p004*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/logistics00/p005*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/logistics00/p010*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/logistics00/p006*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/logistics00/p011*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/logistics00/p009*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/logistics00/p008*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/sokoban-opt11-strips/p10*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/parcprinter-opt11-strips/p05*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/parcprinter-opt11-strips/p09*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/pipesworld-notankage/p15*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/pipesworld-notankage/p03*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/depot/p03*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/miconic/p31*
# ng: ./set1-master-lama-665919-2015-12-16-17-26-step2/miconic/p35*

# plus, removed mystery p03
# tar: mystery/p03.lama.3600.2000000.plan.994: open 不能: 許可がありません
# remaining problems: 211


# change name based on the length

find -name "*.plan.*" | while read f
do
    id=${f##*.}
    len=$(($(wc -l < $f) - 1))
    name=$(basename $f)
    name=${name%%.*}
    mv $f $(dirname $f)/$name.macro.$len.$id
done
find -name "*.out" -delete
