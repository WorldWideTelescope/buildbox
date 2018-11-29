# WWT Builder Box in Vagrant

This repository contains a [Vagrant](https://www.vagrantup.com/) framework for
that compiles the WorldWide Telescope C# code. This lets you develop the core
WWT application on any major operating system.

**Note**: this framework is still a work-in-progress! We are working to evolve
the WWT build systems to make compilation as easy as possible, but we’re not
all the way there yet.

## Overview

This framework works by defining a Vagrant “box” (a virtual machine image)
that is preloaded with the setup needed to compile the WWT codebase. By
running the `driver.sh` script included in the directory containing this
README, you can launch builds of the various components of the WWT framework.

## One-time Setup

Setting up the framework is currently a bit tedious, unfortunately, because we
are trying to be scrupulous about the legalities. These instructions require
downloading about 7 GiB (VM image and Visual Studio) and will take up about 30
GiB of hard disk space.

1. Install [Vagrant](https://www.vagrantup.com/) on your computer.
   Instructions for doing so are beyond the scope of this README; try
   [the official documentation](https://www.vagrantup.com/docs/installation/)
   or Google if needed.
2. Check out this repository on to your local machine, with a command like:
   ```
   git clone --recurse-submodules https://github.com/WorldWideTelescope/buildbox.git
   ```
   (If your check cannot use the `--recurse-submodules` flag, run `git
   submodule update --init --recursive` to fetch the submodules tied to this
   repository.)
3. Inside the buildbox directory, check out one of the WWT application
   repositories. You probably want the “webclient” repository, which can be
   checked out like so:
   ```
   git clone https://github.com/WorldWideTelescope/wwt-web-client.git
   ```
4. [Follow the instructions to set up the base Windows Vagrant box](https://github.com/pkgw/msedgewin10-newssh-box#instructions).
   This procedure will require a download of about 4.5 GiB and, at its
   high-water mark, take up about 30 GiB of disk space.
5. Run `vagrant up` in this directory. This will perform some basic setup of
   your build machine.
6. Use the VirtualBox GUI to “show” your running machine — it will likely have
   a name starting with `buildbox_default_`. If you need to log in, you can do
   so using the password `Passw0rd!`. Click on the circle in the lower-left
   corner of the screen to open the Cortana search box. Type `cmd`. Wait for
   ”Command Prompt” to show up as the best match. Right-click on that entry
   and choose “Run as administrator”. When Windows asks you if you want to let
   this program make changes to your system, choose “Yes”. Finally, at the
   resulting command prompt, run:
   ```
   choco install dotnet3.5
   ```
   The installation will print some messages in red, but should end with text
   saying that it succeeded. Then type `exit` to close the shell. In the
   VirtualBox menu “Machine”, choose “Detach GUI” to close the window and
   detach from the virtual machine’s display.
7. Run `vagrant reload` to reboot the machine and apply system updates.
8. Run `vagrant provision --provision-with stage1` to install Visual Studio.
   This will take a while.
9. **Optional but recommended:** For the time being, if you want to test out
   the webclient site in your browser, you must access it under the hostname
   `MSEDGEWIN10` even though you are really accessing it through your local
   machine. On most systems, you can do this by adding the text `MSEDGEWIN10`
   to the line of `/etc/hosts` that refers to the IP address `127.0.0.1`.
   After making such a modification, the relevant line might look like:
   ```
   127.0.0.1    localhost localhost.localdomain MSEDGEWIN10
   ```

## Operation

Once the box is set up, you can interact with it through the script
`driver.sh`. Run `./driver.sh` without arguments to see help about the
subcommands that it makes available. The following commands will fully rebuild and serve
the web client code:

```
./driver.sh build-web
./driver.sh npm install
./driver.sh npm install -g grunt-cli
./driver.sh grunt sdk dist-css dist-js
./driver.sh serve-web
```

For the last command to work, you need to have followed the last setup step
listed above. Then you will be able to try the webclient by navigating your
browser to <http://MSEDGEWIN10:26993/Default.aspx>.


## Legalities

The .Net Foundation owns the copyright to the work in this repository. It is
licensed under the MIT License.
