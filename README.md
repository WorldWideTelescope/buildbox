# WWT Builder Box in Vagrant

This repository contains a [Vagrant](https://www.vagrantup.com/) framework for
that compiles the WorldWide Telescope C# code. This lets you develop the core
WWT application on any major operating system.

**DANGER**: Even the basics aren't working yet!!!

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
are trying to be scrupulous about the legalities. Here are the steps.

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
5. MORE STUFF HERE.

## Legalities

The .Net Foundation owns the copyright to the work in this repository. It is
licensed under the MIT License.
