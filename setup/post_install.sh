#!/bin/bash

wait-install (){
    while ! which $@
    do
        sleep 1
    done
}

echodo (){
    echo $*
    $*
}

(
    echodo apt-get install -q git
    echodo apt-get install -q emacs24-nox                                             # for everything
    echodo apt-get install -q libcurses-perl                                    # for pbstop
    echodo apt-get install -q build-essential automake make autoconf cmake      # for build
    echodo apt-get install -q libcurl4-openssl-dev                              # for roswell
    echodo apt-get install -q libtool libglib2.0-dev mercurial g++ python flex bison g++-multilib ia32-libs # for fd
    echodo apt-get install -q cgroup-bin libffi-dev                                                         # for CAP
    echodo apt-get install -q htop byobu
) &> apt-get.log &

(
    [ -d roswell/ ] || (
        echodo wait-install git
        echodo git clone -b release https://github.com/roswell/roswell.git
        echodo cd roswell
        echodo wait-install aclocal autoheader automake autoconf
        echodo ./bootstrap
        echodo ./configure
        echodo wait-install make
        echodo make
        echodo make install
    )
) &> roswell.log &

(
    # torque setting
    PATH="/opt/torque/bin:$PATH"
    echodo qmgr -c "create node localhost"
    echodo qmgr -c "set node localhost np=10000"
    echodo pbsnodes -o localhost
    echodo qmgr -c "set queue batch keep_completed=0"
    
) &> torque.log &

cat >> /etc/profile <<EOF
export EDITOR="emacs"
export TZ="Asia/Tokyo"
EOF

cat >> /home/ubuntu/.profile <<EOF
PATH=~/.roswell/bin:\$PATH
EOF

wait

exit 0

