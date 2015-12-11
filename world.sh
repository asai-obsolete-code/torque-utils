#!/bin/bash

export WORLD_HOME=$(dirname $(readlink -ef $0))

. $WORLD_HOME/util/util.sh
. $WORLD_HOME/util/bashlisp.sh
. $WORLD_HOME/template/common.sh

dirs="template util app run aflab-303cluster summarize"

for d in $dirs
do
    PATH=$(readlink -ef $d):$PATH
done


PS1="[World \W] " bash --norc -i


