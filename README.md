psmay's take on `.bashrc.d`
===========================

I'm not the first person to splay the commands of my `.bashrc` into a number of other files to be auto-read from a `~/.bashrc.d/` directory, and I won't be the last.

Features
--------

The defining features of my version are these:

*   Initially, the only scripts to be included are those whose names do not match `__*`, `.*`, or `*.*`.
    *   For example, a script named `startfoo` would be run by default, but a script named `startfoo.sh` would not.
*   Scripts can specify dependencies by saying `#require` at the beginning of a line and following it with a space-delimited list of other script filenames.
    *   A script can require a file that was initially excluded. If a script named `startfoo` contains a line `#require startfoo.sh`, then `startfoo.sh` will be scheduled to be sourced (even though it would otherwise have been excluded) before `startfoo` is sourced.
    *   A script can require a file that would already have been included. If a script named `startfoo` contains a line `#require zotfoo`, then `zotfoo` will be sourced before `startfoo`.
*   Ordering is derived only from dependencies. If a script must wait until after another script has been included, specifying a dependency is the only way to ensure that they run in the correct order.
    *   Any two scripts whose dependencies have already been met can be run in either order, and theoretically the order may change from run to run.
    *   The scheduling does not fall back to alphabetical/lexicographical order.
    *   The scheduling does not fall back to the order in which dependencies were required.
        *   The require line `#require foo bar` is exactly equivalent to `#require bar foo`.

How to use
----------

Create a `~/.bashrc.d/` directory. Populate it with a checkout of this repo (or, even better, a fork of this repo). The only especially critical file to include is `__all`; that is the script that sources other scripts.

Split your existing `.bashrc` into discrete task scripts and place each in a separate file under `~/.bashrc.d/`. Omit any whitespace, periods, or leading `__` in the filenames.

Move your existing `.bashrc` to another place for your future reference.

Create a new `.bashrc`:

    # Instead of editing this file, consider adding/editing a script in
    # ~/.bashrc.d/.
    . ~/.bashrc.d/__all

That's it!

Dependencies
------------

The `#require` mechanism is designed to take care of these problems:

*   Ordering: There is no need to name task scripts to force a sort order. By specifying dependencies, a workable order can be determined automatically without altering filenames.
*   Include-once: If there is a script that is needed by more than one other script (for example, one that contains function definitions and variables), using a dependency in each, instead of sourcing the script directly, helps prevent the script from being run redundantly.

If any of the task scripts must be preceded by another specify a dependency. For example, if `early` must be run earlier than `late`, add the following line to `late`:

    #require early

(No whitespace may appear before `#require`.)

### Circular dependencies

If some script (requires another script which)+ in turn requires the first script, the scheduling logic will croak citing a dependency loop.

This isn't something we can automatically fix—ultimately one script has to be sourced first. Analyze your scripts to determine whether one of the scripts really must precede another. It may be possible to separate one of the scripts into two parts in which only one has the dependency while the other satisfies the other script's dependency.

The idea is documented much better elsewhere.

### Inseparable scripts

If a script must run *immediately* before another script, dependencies may not help.

Say we have three scripts, `early`, `normal`, and `late`, and `late` depends on `early`, but `early` and `normal` have no dependencies. The following are all valid orderings:

*   `early`, `normal`, `late`
*   `early`, `late`, `normal`
*   `normal`, `early`, `late`

One of the possibilities is for `normal` to run between `early` and `late`. Most often this isn't an issue.

If `early` must be run immediately before `late`, it's probable that they should be combined into a single task. One way to do this is to concatenate `early` and `late` into `early-late`. If there are other scripts with dependencies on `early` or `late`, they should be changed into dependencies on `early-late`. After that change, the only valid orderings are

*   `early-late`, `normal`
*   `normal`, `early-late`

And this works.

License
=======

The OSI-approved version of the MIT License (below) applies to this document and all scripts in this repository, insofar as they are substantial enough to protect under copyright.

Copyright © 2014 Peter S. May

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
