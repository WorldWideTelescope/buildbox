#! /bin/bash

function vagrant_up () {
    if vagrant status |grep ^default |grep -q running ; then
        :
    else
        echo "Starting the Vagrant VM ..."
        vagrant up
    fi
}


function run_command () {
    # $1 - capitalized gerund verb to use in user output (e.g. "Building")
    # $2 - the name of the log file (e.g. "wwt-web-client/build.log")
    # $3 - basename of PowerShell script to run (e.g. "build_web.ps1")
    # $4... - extra args to pass to the PowerShell script. Escaping of
    #         arguments could get gnarly.

    gerund="$1"
    logfile="$2"
    script_base="$3"
    shift 3

    vagrant_up
    cfg_tmp=$(mktemp)
    vagrant ssh-config >$cfg_tmp

    echo "$gerund; logs also captured to \"$logfile\" ..."
    ssh -F $cfg_tmp default \
        powershell -NoProfile -NoLogo -InputFormat None -ExecutionPolicy Bypass \
        -File c:\\\\vagrant\\\\$script_base "$@" |& tee "$logfile"
    rm -f $cfg_tmp
}


function cmd_build_web () {
    run_command "Building" "wwt-web-client/build.log" "build_web.ps1"
}


function cmd_clean_web () {
    run_command "Cleaning" "wwt-web-client/clean.log" "build_web.ps1" "/t:clean"
}


function cmd_setup () {
    # Validate arg

    base_box="$1"

    if [ $# -ne 1 ] ; then
        echo >&2 "error: unexpected extra argument(s) after the base box name"
        exit 1
    fi

    # OK, we can get going.

    if [ ! -e feedstocks ] ; then
        echo >&2 "error: create a directory or symbolic link here named \"feedstocks\""
        echo >&2 "       inside of which your feedstocks will reside. For example,"
        echo >&2 "          \"ln -s ~/sw/feedstocks feedstocks\""
        exit 1
    fi

    echo "$base_box" >.cfg_base_box
    echo "Setup complete."
    return 0
}


function cmd_sshfs () {
    # Validate arg

    local_path="$1"

    if [ $# -ne 1 ] ; then
        echo >&2 "error: unexpected extra argument(s) after the local path"
        exit 1
    fi

    # OK, we can get going. Note: My sshfs has a bug where the path to the SSH
    # config file must be absolute. Other options:
    #
    # idmap=user - try to map same-user IDs between filesystems; seems desirable
    # transform_symlinks - make absolute symlinks relative; also seems desirable
    # workaround=rename - make it so that rename-based overwrites work; needed
    #   for Vim to save files

    mkdir -p "$local_path"
    vagrant_up
    cfg_tmp=$(mktemp)
    vagrant ssh-config >$cfg_tmp
    sshfs -F $(realpath $cfg_tmp) -o idmap=user -o transform_symlinks \
          -o workaround=rename default:/C: "$local_path"
    rm -f $cfg_tmp
}


function usage () {
    echo "Usage: $0 COMMAND [arguments...]  where COMMAND is one of:"
    echo ""
    echo "   build-web  Build the web client"
    echo "   setup      Set up the system for operation"
    echo "   sshfs      Mount the Windows filesystem locally using sshfs"
    echo ""
    exit 0
}


# Dispatcher.

command="$1"

if [ -z "$command" ] ; then
    usage
fi

shift

case "$command" in
    build-web)
        cmd_build_web "$@" ;;
    clean-web)
        cmd_clean_web "$@" ;;
    setup)
        cmd_setup "$@" ;;
    sshfs)
        cmd_sshfs "$@" ;;
    *)
        echo >&2 "error: unrecognized COMMAND \"$command\""
        usage ;;
esac
