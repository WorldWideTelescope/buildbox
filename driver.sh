#! /bin/bash
# Copyright 2018-2019 the .Net Foundation
# Licensed under the MIT License

top="$(dirname "$0")"

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
    echo "$gerund; logs also captured to \"$logfile\" ..."
    vagrant winrm -c "powershell -NoProfile -NoLogo -InputFormat None -ExecutionPolicy Bypass \
        -File c:\\\\vagrant\\\\$script_base $*" |& tee "$logfile"
}


function just_run_command () {
    # $1 - basename of PowerShell script to run (e.g. "build_web.ps1")
    # $2... - extra args to pass to the PowerShell script. Escaping of
    #         arguments could get gnarly.

    script_base="$1"
    shift

    vagrant_up
    vagrant winrm -c "powershell -NoProfile -NoLogo -ExecutionPolicy Bypass \
        -File c:\\\\vagrant\\\\$script_base $*"
}


function cmd_build_web () {
    run_command "Building" "$top/wwt-web-client/build.log" "build_web.ps1"
}


function cmd_clean_web () {
    run_command "Cleaning" "$top/wwt-web-client/clean.log" "build_web.ps1" "/t:clean"
}


function cmd_grunt () {
    just_run_command "clientcmd.ps1" "grunt $@"
}


function cmd_npm () {
    just_run_command "clientcmd.ps1" "npm $@"
}


function cmd_nuget () {
    just_run_command "clientcmd.ps1" "nuget $@"
}


function cmd_serve_web () {
    run_command "Serving" "$top/wwt-web-client/serve.log" "serve_web.ps1"
}


function usage () {
    echo "Usage: $0 COMMAND [arguments...]  where COMMAND is one of:"
    echo ""
    echo "   build-web  Build the web client"
    echo "   clean-web  Clean files in the web client"
    echo "   grunt      Run a grunt task in the webclient"
    echo "   npm        Run an npm task in the webclient"
    echo "   nuget      Run a nuget task in the webclient"
    echo "   serve-web  Serve the current web pack on http://MSEDGEWIN10:26993/"
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
    grunt)
        cmd_grunt "$@" ;;
    npm)
        cmd_npm "$@" ;;
    nuget)
        cmd_nuget "$@" ;;
    serve-web)
        cmd_serve_web "$@" ;;
    *)
        echo >&2 "error: unrecognized COMMAND \"$command\""
        usage ;;
esac
