---
title: Shell Scripts
teaching: 20
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Write a shell script that saves a series of commands in a file.
- Run a shell script with `bash`, or make it executable and run it directly.
- Explain the difference between running and sourcing a script.
- Create and activate a Python virtual environment from the shell.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I save and re-use a series of commands?
- What is the difference between running and sourcing a script?
- How do I set up a Python virtual environment in the shell?

::::::::::::::::::::::::::::::::::::::::::::::::::

We are finally ready to see one of the things that makes the shell such a
powerful programming environment.
We are going to take the commands we repeat frequently and save them in files
so that we can re-run all of those operations again later by typing a single
command.
A bunch of commands saved in a file is usually called a **shell script**,
but make no mistake --- these are actually small programs.

Not only will writing shell scripts make your work faster, but also you won't have to retype
the same commands over and over again.
It will also make it more accurate (fewer chances for typos) and more reproducible.
If you come back to your work later (or if someone else finds your work and wants to
build on it), they will be able to reproduce the same results simply by running your
script, rather than having to remember or retype a long list of commands.

## A first script

Let's start by making sure we are in our lesson directory and creating a new
file, `hello.sh`, using the `micro` editor we installed earlier:

```bash
$ cd ~/stfc-carpentries-shell-novice
$ micro hello.sh
```

The file does not exist yet, so `micro` creates it.
Type in the following two lines, then save with <kbd>Ctrl</kbd>+<kbd>S</kbd> and quit with <kbd>Ctrl</kbd>+<kbd>Q</kbd>:

```source
echo "Hello from a shell script!"
echo "The time is $(date)"
```

A script can contain any of the commands we have met so far --- `ls`, `grep`,
`find`, even `sudo apt install`.
This one prints a greeting and uses the command substitution `$()` we saw in the Finding Things episode to put the current date and time into the message.

Once we have saved the file, we can ask the shell to execute the commands it
contains.
Our shell is called `bash`, so we run the following command:

```bash
$ bash hello.sh
```

```output
Hello from a shell script!
The time is Fri Sep 25 14:02:11 UTC 2026
```

Sure enough, our script's output is exactly what we would get if we typed
those commands into the shell one by one.

:::::::::::::::::::::::::::::::::::::::::  callout

## Text vs. Whatever

We usually call programs like Microsoft Word or LibreOffice Writer "text
editors", but we need to be a bit more careful when it comes to programming.
By default, Microsoft Word uses `.docx` files to store not only text, but also
formatting information about fonts, headings, and so on. This extra
information isn't stored as characters and doesn't mean anything to tools
like the shell, which expects files to contain nothing but plain text.
When writing scripts, use a plain text editor such as `micro`, and be careful
to save files as plain text.

::::::::::::::::::::::::::::::::::::::::::::::::::

## Making a script executable

`bash hello.sh` works, but you may have noticed that other commands don't
need `bash` in front of them. We can run our script directly too, but we need
to do two things first.

The first is to add a **shebang** line at the very top of the script:

```source
#!/bin/bash
echo "Hello from a shell script!"
echo "The time is $(date)"
```

The shebang, `#!`, tells the operating system which program should run the
file. Here it says "run this file with `/bin/bash`". (A shebang can point at
other interpreters too --- `#!/usr/bin/env python3` at the top of a `.py` file
is a common sight --- but we will stick to Bash scripts.)

The second step is to mark the file as executable with `chmod`:

```bash
$ chmod +x hello.sh
$ ./hello.sh
```

```output
Hello from a shell script!
The time is Fri Sep 25 14:05:37 UTC 2026
```

Why do we need the `./` in front? When we type a command, the shell searches
a list of directories (stored in the `PATH` variable) for a program with that
name. The current directory is not in that list, so we tell the shell
explicitly: "run `hello.sh` from right here".

:::::::::::::::::::::::::::::::::::::::::  callout

## What is `chmod`?

`chmod` (change mode) sets file permissions.
`chmod +x hello.sh` adds *execute* permission for everyone.
There is more to permissions than this --- who may read or modify a file ---
but `+x` is the part you need to run scripts.

::::::::::::::::::::::::::::::::::::::::::::::::::

## Running vs. sourcing

There is a second, subtler way to run a script: `source`.
The difference matters, so let's see it in action.

Suppose we want a script that takes us to our exercise data.
Create `go_data.sh` with this single command:

```source
cd ~/stfc-carpentries-shell-novice/exercise-data
```

Now run it with `bash` as before, then check where we are:

```bash
$ bash go_data.sh
$ pwd
```

```output
/home/jovyan/stfc-carpentries-shell-novice
```

Nothing happened!
Or rather, it did happen --- but in a *different* shell.
When we run a script with `bash` (or `./script.sh`), a new shell process is
started just for the script. That child shell runs the commands, changes
directory, and then exits, leaving our own shell where it was.

Now try `source` instead:

```bash
$ source go_data.sh
$ pwd
```

```output
/home/jovyan/stfc-carpentries-shell-novice/exercise-data
```

This time our own shell moved.
`source` runs the commands from the file *in the current shell*, as if we had
typed them ourselves.

The rule of thumb:

- Use `bash script.sh` or `./script.sh` for scripts that **do** something
  (process files, install software, print output).
- Use `source script.sh` for scripts that **set up** your current shell
  (change directory, load settings, activate tools).

Go back to the lesson directory with `$ cd ~/stfc-carpentries-shell-novice` before continuing.

## Example: activating a Python virtual environment

The most common script you will *source* in practice is a Python virtual
environment (venv) activation script.

A virtual environment is a private, per-project set of Python packages.
It lets you install and upgrade packages for one project without breaking
another project (or the system Python). Let's create one in our lesson
directory:

```bash
$ cd ~/stfc-carpentries-shell-novice
$ python3 -m venv myenv
```

This creates a folder `myenv` containing a private copy of Python,
`pip`, and --- crucially --- an **activation script**:

```bash
$ ls myenv/bin
```

```output
activate    activate.csh    activate.fish    Activate.ps1
pip         pip3            pip3.12          python
python3     python3.12
```

Activating the environment is a textbook case of *sourcing*:

```bash
$ source myenv/bin/activate
```

```output
(myenv) jovyan@user-1:~/stfc-carpentries-shell-novice $
```

The `(myenv)` prefix on the prompt tells us the environment is active.
Inside it, `python3` and `pip` refer to the venv's own copies:

```bash
$ which python3
```

```output
/home/jovyan/stfc-carpentries-shell-novice/myenv/bin/python3
```

Packages we install now go into the venv, not the system.
As an example, install `pyfiglet` --- the same idea as the `figlet` program
you installed with `apt`, but this time from the Python Package Index:

```bash
$ pip install pyfiglet
```

```output
Collecting pyfiglet
  Downloading pyfiglet-1.0.4-py3-none-any.whl.metadata (7.4 kB)
Installing collected packages: pyfiglet
Successfully installed pyfiglet-1.0.4
```

Then:

```bash
$ python3 -c "import pyfiglet; print(pyfiglet.figlet_format('Hello!'))"
```

```output
 _   _      _ _       _
| | | | ___| | | ___ | |
| |_| |/ _ \ | |/ _ \| |
|  _  |  __/ | | (_) |_|
|_| |_|\___|_|\___/(_)
```

To leave the environment, run `deactivate`. The prefix disappears and
`which python3` again points at the system Python.

To use the environment again later --- including in a fresh terminal ---
you must `source` the activation script again:

```bash
$ source myenv/bin/activate
```

Because activation only changes your *current* shell, running the script
with `bash myenv/bin/activate` would have no lasting effect.
This is why Python guides tell you to `source` the activate script.

:::::::::::::::::::::::::::::::::::::::::  callout

## If the `venv` module is missing

On a plain Ubuntu machine, the `venv` module sometimes needs to be
installed first with `sudo apt install python3.12-venv` --- one more
practical use for the `apt` commands from a few episodes ago.
On our JupyterHub servers it is already available.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  challenge

## A script that keeps a log

Write a script `record_time.sh` that appends the current date and time to a
file called `run_log.txt`, make it executable, and run it twice.
Then use `cat` to check the log.

:::::::::::::::  solution

## Solution

```source
#!/bin/bash
date >> run_log.txt
```

Then:

```bash
$ chmod +x record_time.sh
$ ./record_time.sh
$ ./record_time.sh
$ cat run_log.txt
```

```output
Fri Sep 25 14:20:03 UTC 2026
Fri Sep 25 14:20:07 UTC 2026
```

The `>>` append operator (from the pipes and filters episode) adds a new
line each time the script runs.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  challenge

## Run it or source it?

Your colleague has a script `setup.sh` that sets an alias they use every
day. They complain: "I ran `bash setup.sh` and the alias is gone the moment
the script finishes!" What went wrong, and what should they type instead?

:::::::::::::::  solution

## Solution

`bash setup.sh` runs the script in a new shell that exits when the script
ends, so anything it defines (like the alias) vanishes with it.
They should run `source setup.sh` so the commands execute in their current
shell.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Using LLMs to draft scripts

Tools like ChatGPT are good at drafting shell scripts, and it is fine to use
them --- with care.

- Read every line before you run it, and make sure you understand what it does.
- Test on files you can afford to lose, or on copies first.
- Never paste passwords, API keys or personal data into a prompt.
- Watch out for made-up options: if a flag looks odd, check the `man` page.

A script is a small program --- treat an AI-written one exactly as you would
treat a stranger's code.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Going further

We have kept scripts deliberately simple here. The full Carpentries material
covers variables, command-line arguments and loops in shell scripts --- see
the [original shell-novice lesson](https://swcarpentry.github.io/shell-novice/)
if you want to go further.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

- A shell script is a file of commands, run with `bash script.sh`.
- Add a shebang (`#!/bin/bash`) and `chmod +x` to run a script directly as `./script.sh`.
- `bash script.sh` and `./script.sh` run in a new shell; `source script.sh` runs in the current shell.
- Python virtual environments are activated by *sourcing* their `activate` script and left with `deactivate`.
- Review any script (including AI-drafted ones) line by line before running it.

::::::::::::::::::::::::::::::::::::::::::::::::::
