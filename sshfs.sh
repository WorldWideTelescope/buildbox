#! /bin/bash

function vagrant_up () {
    if vagrant status |grep ^default |grep -q running ; then
        :
    else
        echo "Starting the Vagrant VM ..."
        vagrant up
    fi
}

local_path=winfs

mkdir -p "$local_path"
vagrant_up
cfg_tmp=$(mktemp)
vagrant ssh-config >$cfg_tmp
sshfs -F $(realpath $cfg_tmp) -o idmap=user -o transform_symlinks \
      -o workaround=rename default:/C: "$local_path"
rm -f $cfg_tmp
