#!/bin/bash

# usage:
# find results/set1* -name "*.plan.*" -exec ./rename.sh {} \;
# rename plans into macros

f=$1
id=${f##*.}
len=$(($(wc -l < $f) - 1))
name=$(basename $f)
name=${name%%.*}
mv $f $(dirname $f)/$name.macro.$len.$id &
