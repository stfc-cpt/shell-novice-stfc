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

Type it with<kbd>Shift</kbd> + <kbd>\\</kbd> (backslash).

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

`grep` hence accepts inputs both from a piped output, or from a specific file path as we saw previously. Commands like this are called _filters_.

:::::::::::::::::::::::::::::::::::::::::  callout

At the top of the output, there is a warning:
`WARNING: apt does not have a stable CLI interface. Use with caution in scripts.`

This is just `apt` letting you know to not rely on its piped output when writing shell scripts (which we will look at in the next section.)

But this does show us something interesting: we searched for lines containing `python`, yet this line doesn't contain that word and still appeared. Why wasn't it filtered out?

Every command has three standard streams, which are channels that text flows through:

- **stdin** (standard input): where a command reads its input from. By default this is your keyboard. When you use a pipe, it is the output of the previous command. __This is why `grep python` works without a filename__: with no file given, `grep` reads from stdin.
- **stdout** (standard output): where a command writes its normal results. By default this is your terminal. This is the stream a pipe connects to the next command's stdin, and the stream `>` and `>>` write to files (we will come across these operators soon).
- **stderr** (standard error): where a command writes errors and warnings. By default this is also your terminal, so it looks the same as stdout, but it is a separate stream, and **a pipe does not carry it**.

So the warning, sent via `stderr`, went straight to the screen bypassing `grep`, while the package list went through the pipe and was filtered.

We'll see later how these streams can be handled seperately.

::::::::::::::::::::::::::::::::::::::::::::::::::

We can even chain multiple pipes together, for example say we wanted to count how many "python" related packages we have:

```bash
$ apt list --installed | grep python | wc -l
```

```output
7
```

`wc` is the word-count command. The `-l` flag counts the number of lines.

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

:::::::::::::::::::::::::::::::::::::::::  callout

## Advanced: Redirecting `stdout` and `stderr` separately

Earlier, we saw that `apt` printed a warning that wasn't filtered by `grep`. That is because the warning was written to `stderr`, which a pipe doesn't carry.

Each stream has a number, and we can put that number in front of `>` to say which stream we want to redirect:

| Number | Stream   | Meaning                      | Redirector |
| ------ | -------- | ---------------------------- | ---------- |
| `0`    | `stdin`  | input to the command         | `0>`       |
| `1`    | `stdout` | normal output                | `1>` or `>`|
| `2`    | `stderr` | errors and warnings          | `2>`       |

So `>` on its own is shorthand for `1>`: it redirects `stdout`, which is why errors have still been appearing on our screen whenever we used it.

We can see the two streams separate by discarding `stderr` with `2>`.
The special file `/dev/null` throws away anything written to it:

```bash
$ apt list --installed 2>/dev/null | grep python
```

```output
libpython3-stdlib/now 3.12.3-0ubuntu2.1 amd64 [installed,local]
libpython3.12-minimal/now 3.12.3-1ubuntu0.17 amd64 [installed,local]
...
```

The warning is now gone, because we sent `stderr` to `/dev/null`.

Or, we can discard `stdout` with `1>` (or just `>`):

```bash
$ apt list --installed 1>/dev/null | grep python
```

```output
WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
```

This time the package list was thrown away, so `grep` received nothing to filter and printed nothing.
Only the warning is left, because `stderr` bypassed the pipe and went straight to the screen.

### Saving errors to a file

Like `>`, these operators can write to a real file instead of `/dev/null`.
This lets us keep normal output and errors apart:

```bash
$ apt list --installed 1>packages.txt 2>errors.txt
$ cat errors.txt
```

```output
WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
```

### Combining both streams

Sometimes we want errors to travel down the pipe with everything else.
`2>&1` means "send `stderr` to wherever `stdout` is currently going":

```bash
$ apt list --installed 2>&1 | grep python
```

Now the warning is treated like any other line, so `grep` filters it out too (it doesn't contain `python`).
Put `2>&1` before the pipe, not after it.

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

::::::::::::::::::::::::::::::::::::::: challenge

### Is it installed?

Write a single command that prints `figlet is installed` if `figlet` appears in the list of installed packages, and `figlet is NOT installed` if it doesn't.

Hints: `grep` exits with status `0` if it finds a match and `1` if it doesn't. It will also print any matching lines, but you can send those to `/dev/null`.

Then try the same command with `cowsay`, which you removed earlier.

::::::::::::::::::::::::::::::: solution

```bash
$ apt list --installed 2>/dev/null | grep "^figlet/" > /dev/null && echo "figlet is installed" || echo "figlet is NOT installed"
```

- `2>/dev/null` hides apt's warning.
- `grep "^figlet/"` matches only a package *named* `figlet`, rather than any line mentioning it.
- `> /dev/null` discards the matching line, since we only care whether there was one.
- `&&` runs the first `echo` if `grep` found something. `||` runs the second if it didn't.

Strictly, `A && B || C` isn't a true if/else: if `B` failed, `C` would also run. For two `echo`s that doesn't matter, but in the next episode we'll see how scripts do this properly.

:::::::::::::::::::::::::::::::
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
