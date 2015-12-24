# remove all problems which:
# 
# + failed to expand all nodes within bound under 2GB
# + failed to dump all nodes within bound under 1hrs

# step1: remove when f=10 did not fit in 2GB
find results/set1* -name "*.pddl" | grep -v domain | while read f
do
 (ls ${f%%.pddl}.*.plan.* &> /dev/null) || (rm ${f%%.pddl}*)
done

# step2: remove unnecessary files
find results/set1* -name "*.qsub" -delete
find results/set1* -name "*.err" -delete

# step3: remove when the data transfer did not finish
find results/set1* -name "*.out" | while read f
do
    # ls ${f%%out}plan* | wc -l
    # awk -e '/Number of registered states/{print $5}' < $f
    if ( ! grep -q 'paths written:' $f ) || \
        [ $(ls ${f%%out}plan* 2>/dev/null | wc -l) -lt \
        $(awk -e '/paths written:/{print $3}' < $f) ]
    then
        name=$(basename $f)
        name=${name%%.*}
        echo "ng: $(dirname $f)/$name*"
        rm $(dirname $f)/$name*
        # also remove the domain files
    fi
done

# step4: change name based on the length

find -name "*.plan.*" | while read f
do
    id=${f##*.}
    len=$(($(wc -l < $f) - 1))
    name=$(basename $f)
    name=${name%%.*}
    mv $f $(dirname $f)/$name.macro.$len.$id
done

# step5: remove logfile
find -name "*.out" -delete
