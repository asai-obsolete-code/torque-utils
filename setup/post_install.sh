#!/bin/bash

wait-install (){
    while ! which $@
    do
        sleep 1
    done
}

# (
#     apt-get install -q git
#     apt-get install -q emacs24-nox                                             # for everything
#     apt-get install -q libcurses-perl                                    # for pbstop
#     apt-get install -q build-essential automake make autoconf cmake      # for build
#     apt-get install -q libcurl4-openssl-dev                              # for roswell
#     apt-get install -q libtool libglib2.0-dev mercurial g++ python flex bison g++-multilib ia32-libs # for fd
#     apt-get install -q cgroup-bin libffi-dev                                                         # for CAP
#     apt-get install -q htop byobu
# ) &> apt-get.log &

# (
#     [ -d roswell/ ] || (
#         wait-install git
#         git clone -b release https://github.com/roswell/roswell.git
#         cd roswell
#         wait-install aclocal autoheader automake autoconf
#         ./bootstrap
#         ./configure
#         wait-install make
#         make
#         make install
#     )
# ) &> roswell.log &
# 
# (
#     # torque setting
#     PATH="/opt/torque/bin:$PATH"
#     qmgr -c "create node localhost"
#     qmgr -c "set node localhost np=10000"
#     pbsnodes -o localhost
#     qmgr -c "set queue batch keep_completed=0"
#     
# ) &> torque.log &
# 
# cat >> /etc/profile <<EOF
# export EDITOR="emacs"
# export TZ="Asia/Tokyo"
# EOF

# PATH=~/.roswell/bin:\$PATH

wait
