---
title: Installing Software with apt
teaching: 10
exercises: 5
---

::::::::::::::::::::::::::::::::::::::: objectives

- Explain what a package manager is and why it is preferable to downloading software by hand.
- Update the local package index with `apt update`.
- Search for and install packages from the command line.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I install software on a Linux machine?
- How do I find out what software is available?

::::::::::::::::::::::::::::::::::::::::::::::::::

So far we have used commands that came pre-installed on the system.
Sooner or later you will want to install something new (a better text editor,
a tool for plotting, a new compiler, etc). The usual way to do this is with
a **package manager**.

A package manager keeps a catalogue of thousands of software packages
that someone else has already compiled and packaged for your system.
Instead of hunting for a download page, extracting an archive, and hoping
it works on your machine, you ask the package manager to fetch and
install it for you, along with anything it needs to run.

On Ubuntu and other Debian-family systems (including our JupyterHub
servers), the package manager is `apt`.

## Installing a package

`cowsay` is a small program that makes an ASCII-art cow say things. Let's try to install it.

```bash
$ apt install cowsay
```

```output
E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
```

What's gone wrong?

Installing packages with `apt` requires administrator or *root* privileges.

## Installing a package, but as root

Let's try again to install `cowsay`.

We can run commands as the root superuser by using the `sudo` ("superuser do" or "substitute user, do") command.

```bash
$ sudo apt install cowsay
```

```output
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
E: Unable to locate package cowsay
```

We've come across another common issue, but this time it's a little less clear from the error message what has gone wrong.

`apt` stores a "cached" list of packages on systems: rather than searching for online packages online each time you try to install something,
it keeps a local list of the download links for each package.

Let's double check that the `cowsay` package can't be found in our apt cache with the `apt search` command:

```bash
$ apt search cowsay
```

```output
Sorting... Done
Full Text Search... Done
```

No results!

## Updating our apt cache

An important step before installing or updating packages is to tell `apt` to update its local cached package lists.

We do this with the `apt update` command:

```bash
$ sudo apt update
```

```output
Get:1 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:2 http://archive.ubuntu.com/ubuntu noble InRelease [256 kB]
Get:3 http://security.ubuntu.com/ubuntu noble-security/universe amd64 Packages [1533 kB]
Get:4 http://archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Get:5 http://archive.ubuntu.com/ubuntu noble-backports InRelease [126 kB]
Get:6 http://security.ubuntu.com/ubuntu noble-security/restricted amd64 Packages [1801 kB]
Get:7 http://archive.ubuntu.com/ubuntu noble/restricted amd64 Packages [117 kB]
Get:8 http://security.ubuntu.com/ubuntu noble-security/main amd64 Packages [1245 kB]
Get:9 http://archive.ubuntu.com/ubuntu noble/main amd64 Packages [1808 kB]
Get:10 http://security.ubuntu.com/ubuntu noble-security/multiverse amd64 Packages [50.0 kB]
Get:11 http://archive.ubuntu.com/ubuntu noble/universe amd64 Packages [19.3 MB]
Get:12 http://archive.ubuntu.com/ubuntu noble/multiverse amd64 Packages [331 kB]
Get:13 http://archive.ubuntu.com/ubuntu noble-updates/multiverse amd64 Packages [56.2 kB]
Get:14 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages [1580 kB]
Get:15 http://archive.ubuntu.com/ubuntu noble-updates/restricted amd64 Packages [1960 kB]
Get:16 http://archive.ubuntu.com/ubuntu noble-updates/universe amd64 Packages [2149 kB]
Get:17 http://archive.ubuntu.com/ubuntu noble-backports/universe amd64 Packages [36.0 kB]
Get:18 http://archive.ubuntu.com/ubuntu noble-backports/multiverse amd64 Packages [671 B]
Get:19 http://archive.ubuntu.com/ubuntu noble-backports/main amd64 Packages [49.0 kB]
Fetched 32.7 MB in 3s (12.3 MB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
9 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

We can see above that `apt` searched through the online package lists for Ubuntu, the operating system Jupyter is running on.

It downloaded a copy of each of the lists, 32.7MB of data total, and wrote it to `apt`'s locally cached package list.

Let's once again use `apt search` to check if we can find `cowsay`:

```bash
$ apt search cowsay
```

```output
Sorting... Done
Full Text Search... Done
cowsay/noble 3.03+dfsg2-8 all
  configurable talking cow

cowsay-off/noble 3.03+dfsg2-8 all
  configurable talking cow (offensive cows)

xcowsay/noble 1.6-1build2 amd64
  Graphical configurable talking cow
```

Yes, there are now three packages with `cowsay` in the name in our local cache!

:::::::::::::::::::::::::::::::::::::::::  callout

Above, we used `apt update` to update our local package list cache.

This doesn't update our installed packages, only the cached list of where they can be downloaded from.

After running `apt update`, packages can be actually upgraded using `apt upgrade`.

We saw a hint of this in the output of `apt update` above, it said `9 packages can be upgraded. Run 'apt list --upgradable' to see them.`.

The key point: even though "update" and "upgrade" are synonomous elsewhere, in `apt` they mean different things!

::::::::::::::::::::::::::::::::::::::::::::::::::

## Finally installing cowsay

We're now ready to install our first package:

```bash
$ sudo apt install cowsay
```

```output
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libtext-charwidth-perl
Suggested packages:
  filters cowsay-off
The following NEW packages will be installed:
  cowsay libtext-charwidth-perl
0 upgraded, 2 newly installed, 0 to remove and 9 not upgraded.
Need to get 27.9 kB of archives.
After this operation, 135 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu noble/main amd64 libtext-charwidth-perl amd64 0.04-11build3 [9358 B]
Get:2 http://archive.ubuntu.com/ubuntu noble/universe amd64 cowsay all 3.03+dfsg2-8 [18.6 kB]
Fetched 27.9 kB in 0s (226 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package libtext-charwidth-perl:amd64.
(Reading database ... 46058 files and directories currently installed.)
Preparing to unpack .../libtext-charwidth-perl_0.04-11build3_amd64.deb ...
Unpacking libtext-charwidth-perl:amd64 (0.04-11build3) ...
Selecting previously unselected package cowsay.
Preparing to unpack .../cowsay_3.03+dfsg2-8_all.deb ...
Unpacking cowsay (3.03+dfsg2-8) ...
Setting up libtext-charwidth-perl:amd64 (0.04-11build3) ...
Setting up cowsay (3.03+dfsg2-8) ...
Processing triggers for man-db (2.12.0-4build2) ...
```

Note that it asked us to confirm we wish to proceed by entering `y` before it made any changes.

We could have passed the `-y` flag (i.e. `sudo apt install cowsay -y`) to bypass this, but it's generally best to review what it plans to install/change and decide only then whether to let it proceed.

:::::::::::::::::::::::::::::::::::::::::  callout

In the above output, we can see that `apt` didn't just install `cowsay`, it also installed `libtext-charwidth-perl`.

This is a *dependency*, another package which `apt` knows is required by `cowsay`.

This shows why it's important to check what `apt` plans to do before entering `y` to tell it to proceed: it might install dependencies that we don't want, downgrade packages to old but compatible versions, or automatically remove incompatible packages.

If no dependencies are required, it might not always prompt you to say `y` or `N`.

We also saw some "suggested packages", `filters` and `cowsay-off`. It won't install these by default, but it's letting you know that they might also be useful or related.

::::::::::::::::::::::::::::::::::::::::::::::::::

Once installed, the command is immediately available:

```bash
$ cowsay "Hello from the shell!"
```

```output
 _______________________
< Hello from the shell! >
 -----------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Install Something Yourself

Use `apt search` to find a package called `figlet`, then install it and
use it to print your name in big letters.

:::::::::::::::  solution

## Solution

```bash
$ apt search figlet
$ sudo apt install figlet
$ figlet "Hello!"
```

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Finding packages

We saw that `apt search` looks for packages in our local cache whose name or description matches a term:

```bash
$ apt search chemistry
```

```output
Sorting... Done
Full Text Search... Done
avogadro/noble 1.95.1-2 amd64
  Molecular Graphics and Modelling System
openbabel/noble 3.1.1+dfsg-6ubuntu5 amd64
  Chemical toolbox utilities (cli)
...
```

Not every piece of software is in the Ubuntu repositories.
Sites like [pkgs.org](https://pkgs.org/) catalogue which package a
program lives in across many distributions, and are a good first stop
when `apt search` comes up empty.


`apt list --installed` shows everything currently installed.

We can check if a specific package is installed like so:

```bash
$ sudo apt list --installed cowsay
```

```output
Listing... Done
cowsay/noble,now 3.03+dfsg2-8 all [installed]
```

In the next lesson, we will use *pipes* to show how you might search for partial matches.

:::::::::::::::::::::::::::::::::::::::  challenge

## Removing Packages

The inverse of `apt install` is `apt remove`. Remove `cowsay` from your
system, and check it is gone.

:::::::::::::::  solution

## Solution

```bash
$ sudo apt remove cowsay
$ cowsay "gone?"
```

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

- A package manager installs software and its dependencies from a curated catalogue.
- `apt update` refreshes the catalogue of available packages.
- `apt search [term]` searches for packages; `apt install [package]` installs one.
- `apt remove [package]` uninstalls a package.
- Administrative actions need `sudo`.

::::::::::::::::::::::::::::::::::::::::::::::::::
