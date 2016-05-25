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

write-wasabi-once (){
    echo "Checking for wasabi-post-install in $1"
    if ! grep wasabi-post-install $1
    then
        echo "Writing to $1"
        echo ": wasabi-post-install" >> $1
        cat >> $1
    else
        echo "Found wasabi-post-install, stopped."
    fi
}

(
    echodo apt-get install -y git
    echodo apt-get install -y emacs24-nox                                             # for everything
    echodo apt-get install -y libcurses-perl                                    # for pbstop
    echodo apt-get install -y build-essential automake make autoconf cmake      # for build
    echodo apt-get install -y libcurl4-openssl-dev                              # for roswell
    echodo apt-get install -y libtool libglib2.0-dev mercurial g++ python flex bison g++-multilib ia32-libs # for fd
    echodo apt-get install -y cgroup-bin libffi-dev                                                         # for CAP
    echodo apt-get install -y htop byobu
) |& tee apt-get.log &

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
) |& tee roswell.log &

(
    # torque setting
    PATH="/opt/torque/bin:$PATH"
    echodo qmgr -c "create node localhost"
    echodo qmgr -c "set node localhost np=10000"
    echodo pbsnodes -o localhost
    echodo qmgr -c "set queue batch keep_completed=0"
    
) |& tee torque.log &

write-wasabi-once /etc/profile <<EOF
export EDITOR="emacs"
export TZ="Asia/Tokyo"
EOF

write-wasabi-once /home/ubuntu/.profile <<EOF
PATH=~/.roswell/bin:\$PATH
EOF

wait

exit 0

