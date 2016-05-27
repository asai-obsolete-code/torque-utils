#!/bin/bash -x

echo $_

wait_install (){
    while ! which $@
    do
        sleep 1
    done
}

write_wasabi_once (){
    echo "Checking for wasabi-post-install in $1"
    if ! grep wasabi-post-install $1
    then
        echo "Writing to $1"
        echo "# wasabi-post-install" >> $1
        cat >> $1
    else
        echo "Found wasabi-post-install, stopped."
    fi
}

apt-get install -y git
apt-get install -y emacs24-nox                                  # for everything
apt-get install -y libcurses-perl                               # for pbstop
apt-get install -y build-essential automake make autoconf cmake # for build
apt-get install -y libcurl4-openssl-dev                         # for roswell
apt-get install -y libtool libglib2.0-dev mercurial g++ python flex bison g++-multilib # for fd
apt-get install -y cgroup-bin libffi-dev                                                         # for CAP
apt-get install -y htop byobu

[ -d roswell/ ] || git clone -b release https://github.com/roswell/roswell.git

(
    cd roswell
    wait_install aclocal autoheader automake autoconf
    ./bootstrap
    ./configure
    wait_install make gcc 
    make
    make install
)

# torque setting

/opt/torque/sbin/pbs_mom
/opt/torque/bin/qmgr -c "create node localhost"
/opt/torque/bin/qmgr -c "set node localhost np=1"
/opt/torque/bin/pbsnodes -o localhost
/opt/torque/bin/qmgr -c "set queue batch keep_completed=0"

chmod +x /opt/torque/contrib/pbstop

echo

write_wasabi_once /etc/profile <<EOF
export EDITOR="emacs"
export TZ="Asia/Tokyo"
EOF

write_wasabi_once /etc/sudoers <<EOF
Defaults	env_keep += "PATH EDITOR"
EOF

(
    su ubuntu
    write_wasabi_once /home/ubuntu/.profile <<EOF
export PATH=~/.roswell/bin:/opt/torque/contrib:/opt/torque/bin:/opt/torque/sbin:\$PATH
_byobu_sourced=1 . /usr/bin/byobu-launch
export MAKEFLAGS="-j \$(cat /proc/cpuinfo | grep -c processor)"
if [ "\$color_prompt" = yes ]; then
    PS1='[\[\033[00;34m\]\u\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]]\\$ '
else
    PS1='[\u \W]\\$ '
fi
EOF
)

exit 0

