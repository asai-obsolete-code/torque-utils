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

mkdird (){ [ ! -d $1 ] && mkdir $1 ; cd $1 ; }

apt-get install -y git emacs24-nox libcurses-perl build-essential automake make autoconf cmake libcurl4-openssl-dev libtool libglib2.0-dev mercurial g++ python flex bison g++-multilib cgroup-bin libffi-dev htop byobu bash-completion

echo torque ; (
    pgrep pbs_mom || /opt/torque/sbin/pbs_mom
    pgrep pbs_server && {
        /opt/torque/bin/qmgr -c "set server $(hostname) keep_completed=0,auto_node_np=false,allow_node_submit=true,np_default=18,use_jobs_subdirs=true"
        # /opt/torque/bin/qmgr -c "set queue batch "
        /opt/torque/bin/qmgr -c "create node $(hostname) np=1,properties=dummy"
        /opt/torque/bin/qmgr -c "active queue batch"
        /opt/torque/bin/qmgr -c "active server $(hostname)"
    }
    chmod +x /opt/torque/contrib/pbstop
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

echo lisptmp ; (
    mkdir /tmp/lisptmp /tmp/newtmp
    chown -R ubuntu:ubuntu /tmp/lisptmp /tmp/newtmp
) &

echo home ; (
    cd /home/ubuntu
    su ubuntu
    (
        echo 'export PATH=~/.roswell/bin:/opt/torque/contrib:/opt/torque/bin:/opt/torque/sbin:$PATH'
        echo '_byobu_sourced=1 . /usr/bin/byobu-launch'
        echo 'export MAKEFLAGS="-j $(cat /proc/cpuinfo | grep -c processor)"'
        echo 'PS1="[\u \W]\$ "'
    ) | write_wasabi_once /home/ubuntu/.profile
    source /home/ubuntu/.profile
    export MAKEFLAGS="-j $(cat /proc/cpuinfo | grep -c processor)"
    ln -s /shared repos
    (
        rm -rf .cache
        ln -s repos/.home/Dropbox/ repos/.home/.[a-z]*/ .
        cd repos
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
            ros -Q -e '(ql:quickload :quicklisp-slime-helper)' -q
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

