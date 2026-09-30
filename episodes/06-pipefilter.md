---
title: Pipes and Filters
teaching: 25
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Explain the advantage of linking commands with pipes and filters.
- Combine sequences of commands to get new output
- Redirect a command's output to a file.
- Explain what usually happens if a program or pipeline isn't given any input to process.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I combine existing commands to produce a desired output?
- How can I show only part of the output?

::::::::::::::::::::::::::::::::::::::::::::::::::

Now that we know a few basic commands,
we can finally look at the shell's most powerful feature:
the ease with which it lets us combine existing programs in new ways.

In our previous lesson, we saw how `apt list` can show the packages installed on a machine.
Here is (part of) the full list:

```bash
$ sudo apt list --installed
```

```output
Listing... Done
adduser/noble,now 3.137ubuntu1 all [installed,automatic]
apt/noble-updates,now 2.8.3 amd64 [installed]
base-files/noble-updates,now 13ubuntu10.5 amd64 [installed]
...
```

And before that, we saw how the `grep` command lets us search inside files:

```bash
$ grep -n -w -i "the" haiku.txt
```

```output
1:The Tao that is seen
2:Is not the true Tao, until
6:and the presence of absence:
```

What if we wanted to find all packages related to Python?

## Pipes

We can combine the commands above using a *pipe*, `|`!

Type it by holding <kbd>Shift</kbd> and pressing the <kbd>\</kbd> key.

Let's look at an example:

```bash
$ apt list --installed | grep python
```

```output
WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

libpython3-stdlib/noble-updates,noble-security,now 3.12.3-0ubuntu2.1 amd64 [installed,automatic]
libpython3.12-minimal/noble-updates,noble-security,now 3.12.3-1ubuntu0.17 amd64 [installed,automatic]
libpython3.12-stdlib/noble-updates,noble-security,now 3.12.3-1ubuntu0.17 amd64 [installed,automatic]
python3-minimal/noble-updates,noble-security,now 3.12.3-0ubuntu2.1 amd64 [installed,automatic]
python3.12-minimal/noble-updates,noble-security,now 3.12.3-1ubuntu0.17 amd64 [installed,automatic]
python3.12/noble-updates,noble-security,now 3.12.3-1ubuntu0.17 amd64 [installed,automatic]
python3/noble-updates,noble-security,now 3.12.3-0ubuntu2.1 amd64 [installed,automatic]
```

The pipe, `|`, tells the shell that we want to use the output of the command on the left
as the input of the command on the right.

I.e. we want to take the output of `apt list --installed`, and use it as the input of `grep python`.

We can even chain multiple pipes together, for example say we wanted to find only the "minimal" python packages:

```bash
$ apt list --installed | grep python | grep minimal
```

```output
libpython3.12-minimal/noble-updates,noble-security,now 3.12.3-1ubuntu0.17 amd64 [installed,automatic]
python3-minimal/noble-updates,noble-security,now 3.12.3-0ubuntu2.1 amd64 [installed,automatic]
python3.12-minimal/noble-updates,noble-security,now 3.12.3-1ubuntu0.17 amd64 [installed,automatic]
```

## Other Useful Operators

Other than pipes, there are a couple of other useful operators to chain commands

You can use a semicolon, `;` to run commands one-after-another without piping the outputs

```bash
$ echo Hello; echo World
```

```output
Hello
World
```

Bash also has a logical AND operator `&&`, and a logical OR operator `||`

`&&` will only run the next command if the first one succeeded.

`||` will only run the next if the first one failed.

For example, you might want to only `apt upgrade` your packages if the `apt update` successfully updated your package cache

```bash
$ apt update && sudo apt upgrade
```

```output
Reading package lists... Done
E: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)
E: Unable to lock directory /var/lib/apt/lists/
```

Notice that the `apt update` failed since we didn't use `sudo`. But that meant that the `sudo apt upgrade` was never run.

Or, with the OR `||` operator:
```bash
$ apt update || echo That Failed!
```

```output
Reading package lists... Done
E: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)
E: Unable to lock directory /var/lib/apt/lists/
That Failed!
```

Now `That Failed!` was output since the first command failed.

:::::::::::::::::::::::::::::::::::::::::  callout

Pipe, `|` and OR, `||` mean different things, despite using the same character.

::::::::::::::::::::::::::::::::::::::::::::::::::

## File Redirection

The last useful operators we will try are the redirection operators: the output operator `>` and the append operator `>>`.

These allow you to write the output of commands to files.

For example, say we wanted to store a timestamp of when we did something. We could write the output of the `date` command to a file called `timestamp.txt`:

```bash
$ date > timestamp.txt
```

```output
```

Notice that we didn't get any output, it was sent to the file instead.


```bash
$ ls timestamp.txt
```
```output
timestamp.txt
```

Let's read the file:

```bash
$ cat timestamp.txt
```

```output
Mon Sep 21 15:46:22 UTC 2026
```

If we try to write another timestamp with `>`, it will overwrite the whole file:

```bash
$ date > timestamp.txt && cat timestamp.txt
```

```output
Mon Sep 21 15:48:31 UTC 2026
```

If we want to add to the end of the file instead, we can use the `>>` append operator:

```bash
$ date >> timestamp.txt && cat timestamp.txt
```

```output
Mon Sep 21 15:48:31 UTC 2026
Mon Sep 21 15:49:50 UTC 2026
```
:::::::::::::::::::::::::::::::::::::::::  callout

Be very careful with `>`. It will replace the contents of whatever file it points to!

It's usually best to default to using `>>`.
If the file doesn't exist, it will create it for you anyway

::::::::::::::::::::::::::::::::::::::::::::::::::

### tee
An alternative to the redirect operators is to pipe to the `tee` command.

This will still show you the output, while directing it to a file as well.

`| tee` is equivalent to `>`, it overwrites.
`| tee -a` is equivalent to `>>`, it appends.

```bash
$ echo Hello World | tee message.txt
```

```output
Hello World
```

See that we still see the output in our terminal

:::::::::::::::::::::::::::::::::::::::  challenge

## Cataloging Mythical Creatures

Write a single pipeline command that searches for the `CLASSIFICATION` line across all `.dat` files in `exercise-data/creatures/`, pipes the results into `tee` to write them to `creature_species.txt` while displaying them on screen, and **only if the pipeline succeeds**, prints `"Creature database updated!"`.

:::::::::::::::  solution

## Solution

```bash
$ grep "CLASSIFICATION" creatures/*.dat | tee creature_species.txt && echo "Creature database updated!"
```

**Output:**
```output
creatures/basilisk.dat:CLASSIFICATION: basiliscus vulgaris
creatures/minotaur.dat:CLASSIFICATION: bos hominus
creatures/unicorn.dat:CLASSIFICATION: equus monoceros
Creature database updated!
```

**Explanation:**
- `grep "CLASSIFICATION" creatures/*.dat` searches all creature dat files for taxonomy lines.
- `| tee creature_species.txt` outputs the matches while saving them to `creature_species.txt`.
- `&&` ensures `echo "Creature database updated!"` executes only if the preceding commands return an exit code of `0` (success).

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Browsing long files with `less`

In Finding Things we met `head` and `tail` for looking at the start and the end of a file.
But while we've been managing `apt` packages, `apt` has itself kept a log at
`/var/log/apt/history.log`.
That file is very long, and the interesting part could be anywhere in it.
The tool for browsing is `less`:

```bash
$ less /var/log/apt/history.log
```

We can navigate the same way as we did with `man` pages.

We go up and down with <kbd>↑</kbd> and <kbd>↓</kbd>

To go to the end, press capital <kbd>G</kbd>. And for the start, <kbd>g</kbd>

To search, use <kbd>/</kbd> followed by the word you are searching for.

Sometimes a search will result in multiple hits.
If so, you can move between hits using <kbd>N</kbd> (for moving forward) and
<kbd>Shift</kbd>\+<kbd>N</kbd> (for moving backward).

To **quit** `less`, press <kbd>q</kbd>.

:::::::::::::::::::::::::::::::::::::::: keypoints

- `[command1] | [command2]` streams output from `command1` into input of `command2`.
- `command > [file]` redirects output to a file, overwriting existing contents.
- `command >> [file]` appends output to the end of a file without destroying existing content.
- `[command] | tee [file]` splits output, writing to both the terminal screen and a file simultaneously (`-a` appends).
- `command1 ; command2` runs commands sequentially regardless of success or failure.
- `command1 && command2` runs `command2` ONLY if `command1` succeeds (returns exit code 0).
- `command1 || command2` runs `command2` ONLY if `command1` fails (returns a non-zero exit code).
- `less` allows interactive navigation through text streams or log files (press <kbd>q</kbd> to quit).

::::::::::::::::::::::::::::::::::::::::::::::::::
