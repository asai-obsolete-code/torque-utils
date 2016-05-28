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

mkdird (){ mkdir $1 ; cd $1 ; }

apt-get install -y git
apt-get install -y emacs24-nox                                  # for everything
apt-get install -y libcurses-perl                               # for pbstop
apt-get install -y build-essential automake make autoconf cmake # for build
apt-get install -y libcurl4-openssl-dev                         # for roswell
apt-get install -y libtool libglib2.0-dev mercurial g++ python flex bison g++-multilib # for fd
apt-get install -y cgroup-bin libffi-dev                                                         # for CAP
apt-get install -y htop byobu bash-completion

echo torque ; (
    /opt/torque/sbin/pbs_mom
    /opt/torque/bin/qmgr -c "set server $(hostname) keep_completed=0,auto_node_np=false,allow_node_submit=true,np_default=18"
    # /opt/torque/bin/qmgr -c "set queue batch "
    chmod +x /opt/torque/contrib/pbstop

    while : ; do
        /opt/torque/bin/qmgr -c "create node localhost np=1,state=offline" && break
    done
) &

echo profile ; (
    write_wasabi_once /etc/profile <<EOF
export EDITOR="emacs"
export TZ="Asia/Tokyo"
EOF
) &

echo sudoer ; (
    sed -i 's/\(.*secure_path.*\)/# \1/g' /etc/sudoers
    write_wasabi_once /etc/sudoers <<EOF
Defaults	env_keep += "PATH EDITOR"
EOF
) &



echo home ; (
    cd /home/ubuntu
    (
        echo 'export PATH=~/.roswell/bin:/opt/torque/contrib:/opt/torque/bin:/opt/torque/sbin:$PATH'
        echo '_byobu_sourced=1 . /usr/bin/byobu-launch'
        echo 'export MAKEFLAGS="-j $(cat /proc/cpuinfo | grep -c processor)"'
        echo 'PS1="[\u \W]\$"'
    ) | write_wasabi_once /home/ubuntu/.profile
    source /home/ubuntu/.profile
    
    (
        mkdird repos
        (
            git clone https://github.com/guicho271828/torque-utils.git
            cd torque-utils
            make &
            make mwup-bin &
            make -C sets all &
            wait
        ) &
        (
            git clone -b release https://github.com/roswell/roswell.git
            cd roswell
            ./bootstrap
            ./configure
            make
            sudo make install
        ) &
        wait
    ) &

    (
        mkdird Dropbox
        (
            git clone https://github.com/guicho271828/site-lisp.git
            make -C site-lisp
        ) &
        (
            git clone https://github.com/guicho271828/rcfiles.git
            make -C rcfiles
        ) &
        wait
    ) &
    wait
    chown -R ubuntu:ubuntu /home/ubuntu
) &

wait

exit 0

