---
title: Finding Things
teaching: 25
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Display the contents of a file with `cat`.
- Use `grep` to select lines from text files that match simple patterns.
- Use `find` to find files and directories whose names match simple patterns.
- Use the output of one command as the command-line argument(s) to another command.
- Explain what is meant by 'text' and 'binary' files, and why many common tools don't handle the latter well.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I find files?
- How can I view the contents of a file?
- How can I find things in files?

::::::::::::::::::::::::::::::::::::::::::::::::::

In the same way that many of us now use 'Google' as a
verb meaning 'to find', Unix programmers often use the
word 'grep'.
'grep' is a contraction of 'global/regular expression/print',
a common sequence of operations in early Unix text editors.
It is also the name of a very useful command-line program.

`grep` finds and prints lines in files that match a pattern.
For our examples,
we will use a file that contains three haiku taken from a
[1998 competition](https://web.archive.org/web/19991201042211/http://salon.com/21st/chal/1998/01/26chal.html)
in *Salon* magazine (Credit to authors Bill Torcaso, Howard Korder, and
Margaret Segall, respectively. See
Haiku Error Messages archived
[Page 1](https://web.archive.org/web/20000310061355/http://www.salon.com/21st/chal/1998/02/10chal2.html)
and
[Page 2](https://web.archive.org/web/20000229135138/http://www.salon.com/21st/chal/1998/02/10chal3.html)
.). For this set of examples,
we're going to be working in the writing subdirectory:

```bash
$ cd
$ cd stfc-carpentries-shell-novice/exercise-data/writing
$ cat haiku.txt
```

```output
The Tao that is seen
Is not the true Tao, until
You bring fresh toner.

With searching comes loss
and the presence of absence:
"My Thesis" not found.

Yesterday it worked
Today it is not working
Software is like that.
```

## Viewing files with `cat`

We just used `cat` to display the whole of `haiku.txt` on the screen.

`cat` is short for **concatenate**.
Given one file, it prints that file to the screen;
given several files, it prints them one after the other:

```bash
$ cat haiku.txt haiku.txt
```

```output
The Tao that is seen
Is not the true Tao, until
You bring fresh toner.

With searching comes loss
and the presence of absence:
"My Thesis" not found.

Yesterday it worked
Today it is not working
Software is like that.

The Tao that is seen
Is not the true Tao, until
You bring fresh toner.

With searching comes loss
and the presence of absence:
"My Thesis" not found.

Yesterday it worked
Today it is not working
Software is like that.
```

See how the file appeared twice?
That is where the name comes from: `cat` glues files together.

`cat` always prints the *entire* file.
That is perfect for something short like our haiku,
but it is not how we want to read a large file.
For that we have two more tools: `head` and `tail`.

## Looking at the start and end: `head` and `tail`

Our `writing` directory also contains `LittleWomen.txt`, the full text of
the novel --- over twenty thousand lines.
Try `cat` on it and the screen fills with text faster than you can read it.

```bash
$ cat LittleWomen.txt
```

```output
The Project Gutenberg EBook of Little Women, by Louisa May Alcott

This eBook is for the use of anyone anywhere at no cost and with
almost no restrictions whatsoever...
[ thousands of lines later ]
subscribe to our email newsletter to hear about new eBooks.
```

(Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop a command like this once it is
doing something you did not want.)

To see just the *beginning* of a large file, use `head`.
It prints the first 10 lines by default:

```bash
$ head LittleWomen.txt
```

```output
The Project Gutenberg EBook of Little Women, by Louisa May Alcott

This eBook is for the use of anyone anywhere at no cost and with
almost no restrictions whatsoever.  You may copy it, give it away or
re-use it under the terms of the Project Gutenberg License included
with this eBook or online at www.gutenberg.net


Title: Little Women
```

And `tail` prints the *last* 10 lines.
For log-like files this is often the end you want: recent entries are at the end.

```bash
$ tail LittleWomen.txt
```

```output


Most people start at our Web site which has the main PG search facility:

     http://www.gutenberg.net

This Web site includes information about Project Gutenberg-tm,
including how to make donations to the Project Gutenberg Literary
Archive Foundation, how to help produce our new eBooks, and how to
subscribe to our email newsletter to hear about new eBooks.
```

Both accept the `-n` flag to change the number of lines:

```bash
$ head -n 3 LittleWomen.txt
```

```output
The Project Gutenberg EBook of Little Women, by Louisa May Alcott

This eBook is for the use of anyone anywhere at no cost and with
```

These are good first checks on a log or a data file:
look at the first and last few lines to see what you have,
instead of reading the whole thing.

### Watching a file as it grows: `tail -f`

`tail` also has a follow mode, `tail -f`, which you can use to follow
a file as it grows.

To see this, open a second terminal
(in JupyterLab, click the **+** button and choose **Terminal** again).

In tab 2, run this loop and leave it alone:

```bash
$ cd ~/stfc-carpentries-shell-novice/exercise-data/writing
$ timeout 10m bash -c 'while true; do fortune >> fortunes.txt; sleep 2; done'
```

You do not need to understand this loop yet.
Treat it as a small machine that reads a fortune and appends it to the file
`fortunes.txt`, one every two seconds, for up to 10 minutes.
It prints nothing, and the prompt does not come back while it runs,
because the command has not finished.

You could press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop it, and the prompt returns.
This is worth remembering in general:
<kbd>Ctrl</kbd>+<kbd>C</kbd> stops whatever command is running in the
foreground. (The `>>` writes into the file; we meet it properly in the next
few episodes.)

Instead of stopping it, switch to tab 1 and follow the file:

```bash
$ tail -f fortunes.txt
```

`tail -f` first shows whatever is already in the file, then waits.
Each time the loop appends another fortune, it appears here straight away
(yours will be different):

```output
You will inherit some money or a small piece of land.

Q: How many surrealists does it take to change a light bulb?
A: Two: one to hold the giraffe, one to fill the bathtub
   with brightly colored machine tools.

You like to form new friendships or make new alliances.
```

To finish, press <kbd>Ctrl</kbd>+<kbd>C</kbd> in tab 1 to stop
`tail -f`, then press <kbd>Ctrl</kbd>+<kbd>C</kbd> in tab 2 to stop the
fortune loop. Both prompts come back.

This is how you follow a running job's log:
leave `tail -f` open while the job writes to the file.

Later in the lesson we will also meet `less`,
for browsing a long file one screen at a time.

## Finding lines in files

Going back to our haikus, let's find lines that contain the word 'not' using Grep:

```bash
$ grep not haiku.txt
```

```output
Is not the true Tao, until
"My Thesis" not found.
Today it is not working
```

Here, `not` is the pattern we're searching for.
The grep command searches through the file, looking for matches to the pattern specified.
To use it type `grep`, then the pattern we're searching for and finally
the name of the file (or files) we're searching in.

The output is the three lines in the file that contain the letters 'not'.

By default, grep searches for a pattern in a case-sensitive way.
In addition, the search pattern we have selected does not have to form a complete word,
as we will see in the next example.

Let's search for the pattern: 'The'.

```bash
$ grep The haiku.txt
```

```output
The Tao that is seen
"My Thesis" not found.
```

This time, two lines that include the letters 'The' are outputted,
one of which contained our search pattern within a larger word, 'Thesis'.

To restrict matches to lines containing the word 'The' on its own,
we can give `grep` the `-w` option.
This will limit matches to word boundaries.

Later in this lesson, we will also see how we can change the search behavior of grep
with respect to its case sensitivity.

```bash
$ grep -w The haiku.txt
```

```output
The Tao that is seen
```

Note that a 'word boundary' includes the start and end of a line, so not
just letters surrounded by spaces.
Sometimes we don't
want to search for a single word, but a phrase. We can also do this with
`grep` by putting the phrase in quotes.

```bash
$ grep -w "is not" haiku.txt
```

```output
Today it is not working
```

We've now seen that you don't have to have quotes around single words,
but it is useful to use quotes when searching for multiple words.
It also helps to make it easier to distinguish between the search term or phrase
and the file being searched.
We will use quotes in the remaining examples.

Another useful option is `-n`, which numbers the lines that match:

```bash
$ grep -n "it" haiku.txt
```

```output
5:With searching comes loss
9:Yesterday it worked
10:Today it is not working
```

Here, we can see that lines 5, 9, and 10 contain the letters 'it'.

We can combine options (i.e. flags) as we do with other Unix commands.
For example, let's find the lines that contain the word 'the'.
We can combine the option `-w` to find the lines that contain the word 'the'
and `-n` to number the lines that match:

```bash
$ grep -n -w "the" haiku.txt
```

```output
2:Is not the true Tao, until
6:and the presence of absence:
```

Now we want to use the option `-i` to make our search case-insensitive:

```bash
$ grep -n -w -i "the" haiku.txt
```

```output
1:The Tao that is seen
2:Is not the true Tao, until
6:and the presence of absence:
```

Now, we want to use the option `-v` to invert our search, i.e., we want to output
the lines that do not contain the word 'the'.

```bash
$ grep -n -w -v "the" haiku.txt
```

```output
1:The Tao that is seen
3:You bring fresh toner.
4:
5:With searching comes loss
7:"My Thesis" not found.
8:
9:Yesterday it worked
10:Today it is not working
11:Software is like that.
```

Similar to how the `-r` option applies `cp` to an entire directory's contents,
we can add `-r` (recursive) to our `grep` command
to search for a pattern through all the files in
a directory and its subdirectories.

Let's search for `Yesterday` in the `stfc-carpentries-shell-novice/exercise-data/writing` directory:

```bash
$ grep -r Yesterday .
```

```output
./haiku.txt:Yesterday it worked
./LittleWomen.txt:"Yesterday, when Aunt was asleep and I was trying to be as still as a
./LittleWomen.txt:Yesterday at dinner, when an Austrian officer stared at us and then
./LittleWomen.txt:Yesterday was a quiet day spent in teaching, sewing, and writing in my
```

The order in which files are listed is not significant;
it may differ on your system.

`grep` has lots of other options. To find out what they are, we can type:

```bash
$ grep --help
```

```output
Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERNS in each FILE.
Example: grep -i 'hello world' menu.h main.c
PATTERNS can contain multiple patterns separated by newlines.

Pattern selection and interpretation:
  -E, --extended-regexp     PATTERNS are extended regular expressions
  -F, --fixed-strings       PATTERNS are strings
  -G, --basic-regexp        PATTERNS are basic regular expressions
  -e, --regexp=PATTERNS     use PATTERNS for matching
  -i, --ignore-case         ignore case distinctions in patterns and data
  -w, --word-regexp         match only whole words
  -z, --null-data           a data line ends in 0 byte, not newline

Miscellaneous:
  -v, --invert-match        select non-matching lines
      --help                display this help text and exit
...        ...        ...
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Using `grep`

Which command would result in the following output:

```output
and the presence of absence:
```

1. `grep "of" haiku.txt`
2. `grep -E "of" haiku.txt`
3. `grep -w "of" haiku.txt`
4. `grep -i "of" haiku.txt`

:::::::::::::::  solution

## Solution

The correct answer is 3, because the `-w` option looks only for whole-word matches.
The other options will also match 'of' when part of another word.



:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Wildcards

`grep`'s real power doesn't come from its options, though; it comes from
the fact that patterns can include wildcards. (The technical name for
these is **regular expressions**, which
is what the 're' in 'grep' stands for.) Regular expressions are both complex
and powerful; if you want to do complex searches, please look at the lesson
on [our website](https://librarycarpentry.org/lc-data-intro/01-regular-expressions.html). As a taster, we can
find lines that have an 'o' in the second position like this:

```bash
$ grep -E "^.o" haiku.txt
```

```output
You bring fresh toner.
Today it is not working
Software is like that.
```

We use the `-E` option and put the pattern in quotes to prevent the shell
from trying to interpret it. (If the pattern contained a `*`, for
example, the shell would try to expand it before running `grep`.) The
`^` in the pattern anchors the match to the start of the line. The `.`
matches a single character (just like `?` in the shell), while the `o`
matches an actual 'o'.


::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  challenge

## Finding survey records

Jovyan's survey data is in
`stfc-carpentries-shell-novice/exercise-data/animal-counts/animals.csv`,
which contains one row per date for each species seen:

```source
2012-11-05,deer,5
2012-11-05,rabbit,22
2012-11-05,raccoon,7
2012-11-06,rabbit,19
2012-11-06,deer,2
2012-11-06,fox,4
2012-11-07,rabbit,16
2012-11-07,bear,1
```

1. Move into the `animal-counts` directory and use `cat` to view the whole file.
2. Use `grep` to display every record in which the species was `deer`.

:::::::::::::::  solution

## Solution

```bash
$ cd ~/stfc-carpentries-shell-novice/exercise-data/animal-counts
$ cat animals.csv
$ grep -w "deer" animals.csv
```

```output
2012-11-05,deer,5
2012-11-06,deer,2
```

The `-w` option restricts matches to whole words,
so a hypothetical species called `deerhound` would not be matched.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Searching for files
While `grep` finds lines in files,
the `find` command finds files themselves.
Again,
it has a lot of options;
to show how the simplest ones work, we'll use the `stfc-carpentries-shell-novice/exercise-data`
directory tree shown below.

```output
.
├── animal-counts/
│   └── animals.csv
├── creatures/
│   ├── basilisk.dat
│   ├── minotaur.dat
│   └── unicorn.dat
├── numbers.txt
├── alkanes/
│   ├── cubane.pdb
│   ├── ethane.pdb
│   ├── methane.pdb
│   ├── octane.pdb
│   ├── pentane.pdb
│   └── propane.pdb
└── writing/
    ├── haiku.txt
    └── LittleWomen.txt
```

The `exercise-data` directory contains one file, `numbers.txt` and four directories:
`animal-counts`, `creatures`, `alkanes` and `writing` containing various files.

For our first command,
let's run `find .` (remember to run this command from the `stfc-carpentries-shell-novice/exercise-data` folder).

```bash
$ find .
```

```output
.
./writing
./writing/LittleWomen.txt
./writing/haiku.txt
./creatures
./creatures/basilisk.dat
./creatures/unicorn.dat
./creatures/minotaur.dat
./animal-counts
./animal-counts/animals.csv
./numbers.txt
./alkanes
./alkanes/ethane.pdb
./alkanes/propane.pdb
./alkanes/octane.pdb
./alkanes/pentane.pdb
./alkanes/methane.pdb
./alkanes/cubane.pdb
```

As always, the `.` on its own means the current working directory,
which is where we want our search to start.
`find`'s output is the names of every file **and** directory
under the current working directory.
This can seem useless at first but `find` has many options
to filter the output and in this lesson we will discover some
of them.

The first option in our list is
`-type d` that means 'things that are directories'.
Sure enough, `find`'s output is the names of the five directories (including `.`):

```bash
$ find . -type d
```

```output
.
./writing
./creatures
./animal-counts
./alkanes
```

Notice that the objects `find` finds are not listed in any particular order.
If we change `-type d` to `-type f`,
we get a listing of all the files instead:

```bash
$ find . -type f
```

```output
./writing/LittleWomen.txt
./writing/haiku.txt
./creatures/basilisk.dat
./creatures/unicorn.dat
./creatures/minotaur.dat
./animal-counts/animals.csv
./numbers.txt
./alkanes/ethane.pdb
./alkanes/propane.pdb
./alkanes/octane.pdb
./alkanes/pentane.pdb
./alkanes/methane.pdb
./alkanes/cubane.pdb
```

Now let's try matching by name:

```bash
$ find . -name *.txt
```

```output
./numbers.txt
```

We expected it to find all the text files,
but it only prints out `./numbers.txt`.
The problem is that the shell expands wildcard characters like `*` *before* commands run.
Since `*.txt` in the current directory expands to `./numbers.txt`,
the command we actually ran was:

```bash
$ find . -name numbers.txt
```

`find` did what we asked; we just asked for the wrong thing.

To get what we want,
let's do what we did with `grep`:
put `*.txt` in quotes to prevent the shell from expanding the `*` wildcard.
This way,
`find` actually gets the pattern `*.txt`, not the expanded filename `numbers.txt`:

```bash
$ find . -name "*.txt"
```

```output
./writing/LittleWomen.txt
./writing/haiku.txt
./numbers.txt
```

:::::::::::::::::::::::::::::::::::::::::  callout

## Listing vs. Finding

`ls` and `find` can be made to do similar things given the right options,
but under normal circumstances,
`ls` lists everything it can,
while `find` searches for things with certain properties and shows them.


::::::::::::::::::::::::::::::::::::::::::::::::::

## Finding and searching

It's very common to use `find` and `grep` together.
The first finds files that match a pattern;
the second looks for lines inside those files that match another pattern.
Here, for example, we can find text files that contain the word "searching"
by looking for the string 'searching' in all the `.txt` files in the current directory:

```bash
$ grep "searching" $(find . -name "*.txt")
```

```output
./haiku.txt:With searching comes loss
./LittleWomen.txt:sitting on the top step, affected to be searching for her book, but was
```

When the shell runs this command,
it first executes `find . -name "*.txt"` and replaces the `$()` with that command's output,
so `grep` receives the list of matching files as its arguments.
The output of one command has become the arguments of the next.

:::::::::::::::::::::::::::::::::::::::::  challenge

## Searching your survey data

You have a folder full of survey and analysis files,
and you cannot remember which file contains the records for 7 November 2012.

From `stfc-carpentries-shell-novice/exercise-data`,
find every CSV file in or below the current directory
and search each one for the date `2012-11-07`.

:::::::::::::::  solution

## Solution

```bash
$ grep "2012-11-07" $(find . -name "*.csv")
```

```output
2012-11-07,rabbit,16
2012-11-07,bear,1
```

`find` produces the list of CSV files,
and `grep` searches inside each one.
(`grep` shows the file names only when it searches several files;
here there is just one.)
This is how you search a directory with many files
without opening them one by one.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Binary Files

We have focused exclusively on finding patterns in text files. What if
your data is stored as images, in databases, or in some other format?

A handful of tools extend `grep` to handle a few non text formats. But a
more generalizable approach is to convert the data to text, or
extract the text-like elements from the data. On the one hand, it makes simple
things easy to do. On the other hand, complex things are usually impossible. For
example, it's easy enough to write a program that will extract X and Y
dimensions from image files for `grep` to play with, but how would you
write something to find values in a spreadsheet whose cells contained
formulas?

A last option is to recognize that the shell and text processing have
their limits, and to use another programming language.
When the time comes to do this, don't be too hard on the shell. Many
modern programming languages have borrowed a lot of
ideas from it, and imitation is also the sincerest form of praise.


::::::::::::::::::::::::::::::::::::::::::::::::::

The Unix shell is older than most of the people who use it. It has
survived so long because it is one of the most productive programming
environments ever created --- maybe even *the* most productive. Its syntax
may be cryptic, but people who have mastered it can experiment with
different commands interactively, then use what they have learned to
automate their work. Graphical user interfaces may be easier to use at
first, but once learned, the productivity in the shell is unbeatable.
And as Alfred North Whitehead wrote in 1911, 'Civilization advances by
extending the number of important operations which we can perform
without thinking about them.'





:::::::::::::::::::::::::::::::::::::::: keypoints

- `find` finds files with specific properties that match patterns.
- `cat [file(s)]` prints the contents of files to the screen, joining multiple files together.
- `head` and `tail` show the start or end of a file (10 lines by default, `-n` changes the number); `tail -f` follows a file as it grows.
- `grep` selects lines in files that match patterns.
- `--help` is an option supported by many bash commands, and programs that can be run from within Bash, to display more information on how to use these commands or programs.
- `man [command]` displays the manual page for a given command.
- `$([command])` inserts a command's output in place.

::::::::::::::::::::::::::::::::::::::::::::::::::
